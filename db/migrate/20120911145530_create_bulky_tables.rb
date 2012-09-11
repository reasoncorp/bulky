class CreateBulkyTables < ActiveRecord::Migration
  def up
    create_table :bulky_bulk_updates, force: true do |t|
      t.text :ids,     null: false
      t.text :updates, null: false
      t.integer :initiated_by_id

      t.timestamps
    end
    add_index :bulky_bulk_updates, :initiated_by_id

    create_table :bulky_updated_records, force: true do |t|
      t.integer :bulk_update_id,    null: false
      t.integer :updatable_id,      null: false
      t.string  :updatable_type,    null: false
      t.text    :updatable_changes, null: false
      t.string  :error_message
      t.text    :error_backtrace

      t.timestamps
    end
    add_index :bulky_updated_records, :bulk_update_id
    add_index :bulky_updated_records, [:updatable_type, :updatable_id]
  end

  def down
    drop_table :bulky_updated_records
    drop_table :bulky_bulk_updates
  end
end
