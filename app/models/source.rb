# frozen_string_literal: true

class Source < ApplicationRecord
  belongs_to :dataset, inverse_of: :sources
  has_and_belongs_to_many :authors, inverse_of: :sources
  belongs_to :topic, inverse_of: :sources
  has_many :factors, inverse_of: :source, dependent: :destroy

  has_and_belongs_to_many :refs, 
              class_name: "Source", 
              join_table: :references, 
              foreign_key: :source_id, 
              association_foreign_key: :reference_source_id,
              dependent: :destroy

  @@filter = Stopwords::Snowball::Filter.new('en')

  def self.filter
    @@filter
  end

  def preproc
    parsed = Anystyle.parse self.citation

    puts "-- Got #{parsed.count} sources"
    parsed.each do |source|
      correctly_processed = source[:title] == self.title
      puts "\t:Title correctly identified? #{correctly_processed}"
      if !correctly_processed
        puts "\t:Was  : #{self.title}"
        puts "\t:Found: #{source[:title]}"
        self.title = source[ :title ]
        puts "\t:Fixed"
      end
      if !correctly_processed
        self.author_list = source[ :author ]
      end
      self.authors = []
      author_names = self.author_list.split( ' and ')
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
        self.authors << a
      end
      self.save
    end

    #Take care of item data
    puts '--------- Factors'
    self.factors.each do |factor|
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
        factor.words << word_obj
      end
      factor.save
    end
  end
end
