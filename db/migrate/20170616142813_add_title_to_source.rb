class AddTitleToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :title, :string
  end
end
