# frozen_string_literal: true

class Dataset < ApplicationRecord
  belongs_to :user, inverse_of: :datasets
  has_many :sources, inverse_of: :dataset, dependent: :destroy
  has_many :factors, through: :sources
  has_many :words, through: :factors
  has_many :stems, through: :words
end
