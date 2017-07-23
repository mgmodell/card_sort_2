class AddProcessedToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :processed, :boolean
  end
end
