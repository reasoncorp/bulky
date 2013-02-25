# This migration comes from bulky_engine (originally 20130221191818)
class AddCompletedColumnToUpdatedRecords < ActiveRecord::Migration
  def up
    add_column :bulky_updated_records, :completed, :boolean, after: :error_backtrace, default: false, null: false
  end

  def down
    remove_column :bulky_updated_records, :completed
  end
end
