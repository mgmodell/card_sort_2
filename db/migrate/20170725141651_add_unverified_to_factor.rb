class AddUnverifiedToFactor < ActiveRecord::Migration[5.1]
  def change
    add_column :factors, :unverified, :text
  end
end
