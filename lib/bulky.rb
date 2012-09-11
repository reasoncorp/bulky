require "bulky/engine"

module Bulky
  extend self
  
  def enqueue_update(model, ids, updates)
    ids.each do |update_id|
      Resque.enqueue(Bulky::Updater, model.name, update_id, updates)
    end
  end

  def parse_ids(ids)
    ids.gsub("\n", ',').split(',').reject(&:blank?)
  end

end

require 'bulky/updater'
