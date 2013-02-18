class Bulky::BulkUpdate < ActiveRecord::Base

  self.table_name = 'bulky_bulk_updates'

  serialize :updates, Hash
  serialize :ids,     Array

  validates :ids, :updates, presence: true

  has_many :updated_records, class_name: 'Bulky::UpdatedRecord', foreign_key: :bulk_update_id, dependent: :destroy

  validates_each :updates do |record, attr, value|
    record.errors[:updates] << "must be a hash" unless Hash === value
  end

  validates_each :ids do |record, attr, value|
    record.errors[:ids] << "must be an Array" unless Array === value
  end

  scope :needs_notification, where(notified: false)

  scope :belongs_to_user, lambda { |user_id| where("initiated_by_id = ? OR initiated_by_id IS ?", user_id, nil) }
  
  def mark_as_notified
    self.notified = true
    save!
  end

  # def self.retry(model, ids, updates, user_id)
  #   Bulky.enqueue_update(model, ids, updates, user_id)
  #   redirect_to bulky_edit_path(model), notice: I18n.t('flash.notice.enqueue_update')
  # end
end
