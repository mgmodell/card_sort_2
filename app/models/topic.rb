# frozen_string_literal: true

class Topic < ApplicationRecord
  has_many :sources, inverse_of: :topic
end
