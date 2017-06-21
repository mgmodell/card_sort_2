# frozen_string_literal: true

class CreateDatasets < ActiveRecord::Migration[5.1]
  def change
    create_table :datasets do |t|
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
