class CreateReferencesTable < ActiveRecord::Migration[5.1]
  def self.up
    create_table :references, id: false do |t|
      t.integer :source_id
      t.integer :reference_source_id
    end

    add_index(:references, [:source_id, :reference_source_id], :unique => true)
    add_index(:references, [:reference_source_id, :source_id], :unique => true)
  end

  def self.down
      remove_index(:references, [:reference_source_id, :source_id])
      remove_index(:references, [:source_id, :reference_source_id])
      drop_table :references
  end
end
