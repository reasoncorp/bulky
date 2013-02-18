require "bulky/engine"

module Bulky
  extend self
  
  def enqueue_update(model, ids, updates, user_id=nil)
    bulk_update = log_bulk_update(ids, updates, user_id)

    ids.each do |update_id|
      Resque.enqueue(Bulky::Updater, model.name, update_id, bulk_update.id)
    end
  end

  def parse_ids(ids)
    ids.gsub("\n", ',').split(',').map(&:strip).reject(&:blank?)
  end

  def log_bulk_update(ids, updates, user_id)
    Bulky::BulkUpdate.create! do |bu|
      bu.initiated_by_id = user_id
      bu.ids             = ids
      bu.updates         = updates
    end
  end


end

require 'bulky/updater'
require 'bulky/notifier'
