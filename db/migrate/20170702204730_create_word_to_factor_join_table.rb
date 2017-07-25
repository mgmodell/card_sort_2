# frozen_string_literal: true

class CreateWordToFactorJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :words, :factors do |t|
      # t.index [:word_id, :factor_id]
      t.index %i[factor_id word_id], unique: true
    end
  end
end
