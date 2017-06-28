# frozen_string_literal: true

class Factor < ApplicationRecord
  belongs_to :source, inverse_of: :factors
end
