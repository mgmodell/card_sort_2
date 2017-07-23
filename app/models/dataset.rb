# frozen_string_literal: true

class Dataset < ApplicationRecord
  belongs_to :user, inverse_of: :datasets
  has_many :sources, inverse_of: :dataset, dependent: :destroy
  has_many :factors, through: :sources
  has_many :words, through: :factors
  has_many :stems, through: :words

  def percent_processed
    ( 100 * sources.where( processed: true ).count.to_f / sources.count ).to_i
  end
end
