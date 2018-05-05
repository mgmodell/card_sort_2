class AddDiscardedToSources < ActiveRecord::Migration[5.2]
  def change
    add_column :sources, :discarded, :boolean
  end
end
