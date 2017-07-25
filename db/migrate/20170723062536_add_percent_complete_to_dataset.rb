# frozen_string_literal: true

class AddPercentCompleteToDataset < ActiveRecord::Migration[5.1]
  def change
    add_column :datasets, :load_pct, :integer
  end
end
