class CreateSynonymJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :words, :synonyms do |t|
      # t.index [:word_id, :synonym_id]
      t.index [:synonym_id, :word_id], unique: true
    end
  end
end
