class AddTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token, :text
    add_column :users, :expires_at, :integer
  end
end
