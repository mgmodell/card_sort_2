# frozen_string_literal: true

class Word < ApplicationRecord
  has_and_belongs_to_many :factors, inverse_of: :words
  has_and_belongs_to_many :synonyms, inverse_of: :words
  belongs_to :stem, inverse_of: :words
end
