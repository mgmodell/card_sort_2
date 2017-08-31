class AddStatsToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :stats_cache, :text
  end
end
