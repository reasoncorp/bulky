class Bulky::BulkUpdate < ActiveRecord::Base
  self.table_name = 'bulky_bulk_updates'

  serialize :updates, Hash
  serialize :ids,     Array

  validates :ids, :updates, presence: true

  has_many :updated_records, class_name: 'Bulky::UpdatedRecord', foreign_key: :bulk_update_id
end
