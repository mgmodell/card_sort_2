# frozen_string_literal: true

class Dataset < ApplicationRecord
  belongs_to :user, inverse_of: :datasets
  has_many :sources, inverse_of: :dataset, dependent: :destroy
  has_many :factors, through: :sources
  has_many :words, through: :factors
  has_many :stems, through: :words
  has_many :synonyms, through: :words

  def percent_processed
    (100 * sources.where(processed: true).count.to_f / sources.count).to_i unless sources.count == 0
  end

  def get_word_counts
    counts = Hash.new
    sources.find_each do |source|
      counts.merge!( source.get_word_counts ){|key,v1,v2| v1 + v2 }
    end
    counts
  end

  def get_stem_counts
    counts = Hash.new
    sources.each do |source|
      counts.merge!( source.get_stem_counts ){|key,v1,v2| v1 + v2 }
    end
    counts
  end

  def get_synonym_counts
    counts = Hash.new
    sources.each do |source|
      counts.merge!( source.get_synonym_counts ){|key,v1,v2| v1 + v2 }
    end
    counts
  end
end
