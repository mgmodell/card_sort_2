# frozen_string_literal: true

class AddCachesToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :word_cache, :binary, limit: 20.megabyte
    add_column :sources, :stem_cache, :binary, limit: 20.megabyte
    add_column :sources, :synonym_cache, :binary, limit: 20.megabyte
  end
end
