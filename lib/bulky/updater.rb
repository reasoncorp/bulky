module Bulky
  class Updater

    QUEUE = @queue = :bulky_updates

    def self.perform(model_name, update_id, updates)
      model_name.constantize.find(update_id).update_attributes!(updates)
    end

  end
end
