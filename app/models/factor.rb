class Factor < ApplicationRecord
  belongs_to :source, inverse_of: factors
end
