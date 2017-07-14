# frozen_string_literal: true

class AddTitleToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :title, :text
  end
end
