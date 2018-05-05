# frozen_string_literal: true

class PreProcSourceJob < ApplicationJob
  queue_as :internal

  def perform(source:)
    parsed = Anystyle.parse source.citation

    parsed.each do |parsed_source|
      correctly_processed = parsed_source[:title] == source.title
      source.title = parsed_source[:title].capitalize unless correctly_processed
      source.author_list = parsed_source[:author] unless correctly_processed
      unless source.author_list.blank?
        source.authors = []
        author_names = source.author_list.split(' and ')
        author_names.each do |name|
          unless name.blank? || name = ', '
            name_components = name.split(', ')
            g_name =  name_components[1].capitalize
            f_name = name_components[0].split(/\W+/).map(&:capitalize) * ' '

            a = Author.where(given_name: g_name,
                             family_name: f_name).take
            if a.nil?
              a = Author.create(
                given_name: g_name,
                family_name: f_name
              )
            end
            source.authors << a
          end
        end
      end
      source.save
    end

    # Take care of item data
    source.factors.each do |factor|
      filtered = Source.filter.filter(factor.text.downcase.split(/\W+/))
      factor.words = []
      filtered.each do |word|
        unless word.length < 3
          result = Spellchecker.check(word, dictionary = 'en')[0]
          unless word.empty?
            word_obj = Word.where(raw: result[:original]).take

            if word_obj.nil?
              if result[:correct]
                stemmed = result[:original].stem
                stem = Stem.where(word: stemmed).take
                stem = Stem.create(word: stemmed) if stem.nil?
                word_obj = Word.create(raw: result[:original], stem: stem)
              else
                if factor.unverified.blank?
                  factor.unverified = result[:original]
                else
                  factor.unverified += ' ' + result[:original]
                end
              end
            end
            if word_obj.present? && factor.words.where(id: word_obj).empty?
              factor.words << word_obj
            end
          end
        end
      end
      factor.save
    end
    # Process the terms
    require 'zlib'
    to_cache = source.words.group(:raw).count.to_json
    source.word_cache = Base64.encode64( Zlib::Deflate.deflate( to_cache ) )
    puts "Words:    Original: #{to_cache.size} -> Deflated: #{source.word_cache.size}"
    to_cache = source.stems.group(:word).count.to_json
    source.stem_cache = Base64.encode64( Zlib::Deflate.deflate( to_cache ) )
    puts "Stems:    Original: #{to_cache.size} -> Deflated: #{source.stem_cache.size}"
    to_cache = source.synonyms.group(:word).count.to_json
    source.synonym_cache = Base64.encode64( Zlib::Deflate.deflate( to_cache ) )
    puts "Synonyms: Original: #{to_cache.size} -> Deflated: #{source.synonym_cache.size}"

    stats = {}
    stats['top words'] = source.words.group(:raw).count.values.extend(DescriptiveStatistics).descriptive_statistics
    stats['top synonyms'] = source.synonyms.group(:word).count.values.extend(DescriptiveStatistics).descriptive_statistics
    stats['top stems'] = source.stems.group(:word).count.values.extend(DescriptiveStatistics).descriptive_statistics

    source.stats_cache = stats.to_json

    source.processed = true
    source.save
  end
end
