class PreProcSourceJob < ApplicationJob
  queue_as :internal

  def perform(source:)
    parsed = Anystyle.parse source.citation

    puts "-- Got #{parsed.count} sources"
    parsed.each do |parsed_source|
      correctly_processed = parsed_source[:title] == source.title
      puts "\t:Title correctly identified? #{correctly_processed}"
      if !correctly_processed
        puts "\t:Was  : #{source.title}"
        puts "\t:Found: #{parsed_source[:title]}"
        source.title = parsed_source[ :title ]
        puts "\t:Fixed"
      end
      if !correctly_processed
        source.author_list = parsed_source[ :author ]
      end
      unless source.author_list.blank?
        source.authors = []
        author_names = source.author_list.split( ' and ')
        author_names.each do |name|
          name_components = name.split( ', ')
          g_name =  name_components[ 1 ]
          f_name = name_components[ 0 ]

          a = Author.where( given_name: g_name,
                            family_name: f_name ).take
          if a.nil?
            puts "\t: #{g_name} #{f_name} not found"
            a = Author.create(
                            given_name: g_name, 
                            family_name: f_name )
          end
          puts "\tAuthor: #{a.given_name} #{a.family_name}"
          source.authors << a
        end
      end
      source.save
    end

    #Take care of item data
    puts '--------- Factors'
    source.factors.each do |factor|
      puts "\t\t #{factor.text}"

      filtered = Source.filter.filter( factor.text.split(/\W+/) )
      puts "\t\t\t split: #{factor.text.split(/\W+/)}"
      puts "\t\t\t filt:  #{filtered}"
      filtered.each do |word|
        result = Spellchecker.check( word, dictionary='en' )[0]
        word_obj = Word.where( raw: result[:original] ).take

        if word_obj.nil?
          stemmed = result[:correct] ? result[:original].stem :
                              result[:suggestions][0].stem
          puts "\t\t\t stemmed: #{stemmed}"
          stem = Stem.where( word: stemmed ).take
          if stem.nil?
            stem = Stem.create( word: stemmed )
          end
          word_obj = Word.create( raw: result[:original], stem: stem )
        end
        word_found = factor.words.where( id: word_obj )
        if word_found.count == 1
          puts "which of the following is: #{word_found.take.raw}?"
          factor.words.each do |wd|
            puts "----#{wd.raw}"
          end
        else
          factor.words << word_obj
        end
      end
      factor.save
    end
    source.processed = true
    source.save
  end
end
