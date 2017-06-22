# frozen_string_literal: true

class Source < ApplicationRecord
  belongs_to :dataset, inverse_of: :sources
  has_many :authors, inverse_of: :source
  belongs_to :topic, inverse_of: :sources
end
