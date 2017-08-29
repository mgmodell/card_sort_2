# frozen_string_literal: true

class AddSynCheckedToWord < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :syn_checked, :boolean, null: false, default: false
  end
end
