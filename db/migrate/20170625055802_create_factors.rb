# frozen_string_literal: true

class CreateFactors < ActiveRecord::Migration[5.1]
  def change
    create_table :factors do |t|
      t.references :source, foreign_key: true
      t.text :text

      t.timestamps
    end
  end
end
