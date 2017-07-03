# frozen_string_literal: true

class Factor < ApplicationRecord
  has_and_belongs_to_many :words, inverse_of: :factors
  belongs_to :source, inverse_of: :factors
end
