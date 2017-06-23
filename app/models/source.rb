# frozen_string_literal: true

class Source < ApplicationRecord
  belongs_to :dataset, inverse_of: :sources
  has_and_belongs_to_many :authors, inverse_of: :sources
  belongs_to :topic, inverse_of: :sources
  belongs_to :user, inverse_of: :sources
end
