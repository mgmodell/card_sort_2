# frozen_string_literal: true

class AddDataSetToSource < ActiveRecord::Migration[5.1]
  def change
    add_reference :sources, :dataset, foreign_key: true
  end
end
