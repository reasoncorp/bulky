require "resque"
require "bulky/engine"

module Bulky
  
  def self.update(model, ids, updates)
    ids.each do |update_id|
      Resque.enqueue(Bulky::Updater, model.name, update_id, updates)
    end
  end

end

require 'bulky/updater'
