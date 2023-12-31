# frozen_string_literal: true

class Source < ApplicationRecord
  default_scope { where( discarded: false ).order(:citation) }
  belongs_to :dataset, inverse_of: :sources, optional: true
  has_and_belongs_to_many :authors, inverse_of: :sources
  belongs_to :topic, inverse_of: :sources
  has_many :factors, inverse_of: :source, dependent: :destroy
  has_many :words, through: :factors
  has_many :stems, through: :words
  has_many :synonyms, through: :words

  has_and_belongs_to_many :refs,
                          class_name: 'Source',
                          join_table: :references,
                          foreign_key: :source_id,
                          association_foreign_key: :reference_source_id,
                          dependent: :destroy

  @@filter = Stopwords::Snowball::Filter.new('en')

  def self.filter
    @@filter
  end

  def preproc
    self.processed = false
    save
    PreProcSourceJob.perform_later(source: self)
  end

  def add_refs(source_text:)
    self.refs_processed = false
    save
    AddRefsFromBiblioJob.perform_later(source_text: source_text, source: self)
  end

  def unverifieds
    unverifieds = []
    factors.each do |factor|
      unverifieds.concat(factor.unverified.split(/\W+/)) unless factor.unverified.blank?
    end
    unverifieds
  end

  def get_word_counts
    require 'zlib'
    word_counts = nil
    if word_cache.blank?
      word_counts = words.group( :raw ).count
    else
      word_counts = Zlib::Inflate.inflate( Base64.decode64(word_cache) )
      word_counts = JSON.parse( word_counts )
    end
    word_counts
  end

  def get_stem_counts
    require 'zlib'
    stem_cache.blank? ? stems.group(:word).count : 
        JSON.parse( Zlib::Inflate.inflate( Base64.decode64(stem_cache) ) )
  end

  def get_synonym_counts
    synonym_cache.blank? ? synonyms.group(:word).count :
        JSON.parse( Zlib::Inflate.inflate( Base64.decode64(synonym_cache) ) )
  end
end
