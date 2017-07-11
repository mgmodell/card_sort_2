class Word < ApplicationRecord
  has_and_belongs_to_many :factors, inverse_of: :words
  belongs_to :stem, inverse_of: :words
end
