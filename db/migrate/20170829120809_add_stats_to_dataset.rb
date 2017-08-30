class AddStatsToDataset < ActiveRecord::Migration[5.1]
  def change
    add_column :datasets, :stats_cache, :text
  end
end
