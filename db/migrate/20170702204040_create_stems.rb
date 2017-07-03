class CreateStems < ActiveRecord::Migration[5.1]
  def change
    create_table :stems do |t|
      t.string :word

      t.timestamps
    end
  end
end
