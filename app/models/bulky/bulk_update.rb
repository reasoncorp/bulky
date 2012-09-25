class Bulky::BulkUpdate < ActiveRecord::Base
  self.table_name = 'bulky_bulk_updates'

  serialize :updates, Hash
  serialize :ids,     Array

  validates :ids, :updates, presence: true

  has_many :updated_records, class_name: 'Bulky::UpdatedRecord', foreign_key: :bulk_update_id

  validates_each :updates do |record, attr, value|
    record.errors[:updates] << "must be a hash" unless Hash === value
  end

  validates_each :ids do |record, attr, value|
    record.errors[:ids] << "must be an Array" unless Array === value
  end
end
