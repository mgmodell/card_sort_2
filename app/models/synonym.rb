class Synonym < ApplicationRecord
  has_and_belongs_to_many :words, inverse_of: :synonyms
end
