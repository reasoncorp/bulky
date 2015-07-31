module Bulky
  module Worker
    include Sidekiq::Worker

    def perform(model_name, update_id, bulk_update_id)
      model = model_name.constantize.find(update_id)
      Bulky::Updater.new(model, bulk_update_id).update!
    end

  end
end
