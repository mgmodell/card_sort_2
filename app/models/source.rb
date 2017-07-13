# frozen_string_literal: true

class Source < ApplicationRecord
  belongs_to :dataset, inverse_of: :sources
  has_and_belongs_to_many :authors, inverse_of: :sources
  belongs_to :topic, inverse_of: :sources
  has_many :factors, inverse_of: :source

  has_and_belongs_to_many :refs, 
              class_name: "Source", 
              join_table: :references, 
              foreign_key: :source_id, 
              association_foreign_key: :reference_source_id

  def preproc
    parsed = Anystyle.parse self.citation
    puts "-- Got #{parsed.count} sources"
    parsed.each do |source|
      correctly_processed = source[:author] == self.author_list
      puts "\t:Author correctly identified? #{correctly_processed}"
      if !correctly_processed
        puts "\t:Was  : #{self.author_list}"
        puts "\t:Found: #{source[:author]}"
        self.author_list = source[ :author ]
        puts "\t:Fixed"
      end
      self.authors = []
      puts "a_list = #{self.author_list}"
      author_names = self.author_list.split( ' and ')
      puts "names: #{author_names}"
      puts "count #{author_names.count}"
      author_names.each do |name|
        name_components = name.split( ', ')
        g_name =  name_components[ 1 ]
        f_name = name_components[ 0 ]

        puts "\t: given_name: #{g_name}"
        puts "\t: family_name: #{f_name}"
        a = Author.where( given_name: g_name,
                          family_name: f_name )
        if a.nil?
          puts "\t: #{g_name} #{f_name} not found"
          a = Author.create(
                          given_name: g_name, 
                          family_name: f_name )
        end
        self.authors << a
      end
      self.save
    end
  end
end
