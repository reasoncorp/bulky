class AddViewedColumnToBulkyBulkUpdates < ActiveRecord::Migration
  def up
    add_column :bulky_bulk_updates, :notified, :boolean, after: :initiated_by_id, null: false, default: false
  end

  def down
    remove_column :bulky_bulk_updates, :notified
  end
end
