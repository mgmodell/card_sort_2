# frozen_string_literal: true

class Dataset < ApplicationRecord
  belongs_to :user, inverse_of: :datasets
  has_many :sources, inverse_of: :dataset
end
