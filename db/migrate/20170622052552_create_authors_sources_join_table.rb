# frozen_string_literal: true

class CreateAuthorsSourcesJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :authors, :sources do |t|
      # t.index [:author_id, :source_id]
      t.index %i[source_id author_id], unique: true
    end
  end
end
