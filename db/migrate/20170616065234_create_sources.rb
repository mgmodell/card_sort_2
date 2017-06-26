# frozen_string_literal: true

class CreateSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.text :citation
      t.string :author_list
      t.integer :year
      t.string :purpose
      t.references :topic
      t.string :discard_reason

      t.timestamps
    end
  end
end
