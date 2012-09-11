class Bulky::UpdatedRecord < ActiveRecord::Base
  self.table_name = 'bulky_updated_records'

  serialize :updatable_changes, Hash

  validates :bulk_update_id, :updatable_id, :updatable_type, :updatable_changes, presence: true

  belongs_to :bulk_update, class_name: 'Bulky::BulkUpdate', foreign_key: :bulk_update_id
  belongs_to :updatable, polymorphic: true

  validates_each :updatable_changes do |record, attr, value|
    record.errors[:updatable_changes] << "must be a hash" unless Hash === value
  end

end
