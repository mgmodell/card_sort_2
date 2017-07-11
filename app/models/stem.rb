class Stem < ApplicationRecord
  has_many :words, inverse_of: :stem
end
