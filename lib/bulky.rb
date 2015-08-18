require "bulky/engine"

module Bulky
  extend self
  
  def enqueue_update(model, ids, updates)
    bulk_update = log_bulk_update(ids, updates)

    ids.each do |update_id|
      Bulky::Worker.perform_async model.name, update_id, bulk_update.id
    end
  end

  def parse_ids(ids)
    ids.gsub("\n", ',').split(',').map(&:strip).reject(&:blank?)
  end

  def log_bulk_update(ids, updates)
    Bulky::BulkUpdate.create! do |bu|
      bu.ids     = ids
      bu.updates = updates
    end
  end

end

require 'bulky/model'
require 'bulky/updater'
require 'bulky/worker'
