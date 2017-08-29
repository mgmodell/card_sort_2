# frozen_string_literal: true

class AddCachesToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :word_cache, :text
    add_column :sources, :stem_cache, :text
    add_column :sources, :synonym_cache, :text
  end
end
