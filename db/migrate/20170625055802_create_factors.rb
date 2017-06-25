class CreateFactors < ActiveRecord::Migration[5.1]
  def change
    create_table :factors do |t|
      t.references :source, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
