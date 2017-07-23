class AddProcessedToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :processed, :boolean
    add_column :sources, :refs_processed, :boolean
  end
end
