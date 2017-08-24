# frozen_string_literal: true

class Source < ApplicationRecord
  default_scope { order(:citation) }
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
      unverifieds.concat( factor.unverified.split(/\W+/) ) unless factor.unverified.blank?
    end
    unverifieds
  end
end
