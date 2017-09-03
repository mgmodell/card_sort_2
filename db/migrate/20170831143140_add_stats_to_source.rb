class AddStatsToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :stats_cache, :binary, limit: 10.megabyte
  end
end
