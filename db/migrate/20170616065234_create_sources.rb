class CreateSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.string :citation
      t.string :authors
      t.integer :year
      t.string :purpose
      t.references :topic
      t.string :discard_reason

      t.timestamps
    end
  end
end
