module Bulky
  class Updater

    attr_reader :model, :bulk_update

    def self.perform(model_name, update_id, bulk_update_id)
      model = model_name.constantize.find(update_id)
      new(model, bulk_update_id).update!
    end

    def initialize(model, bulk_update_id)
      @bulk_update = Bulky::BulkUpdate.find(bulk_update_id)
      @model       = model
    end

    def log
      @log ||= bulk_update.updated_records.build { |r| r.updatable = model }
    end

    def strong_updates
      ActionController::Parameters.new(bulk_update.updates)
    end

    def updates
      @updates ||= strong_updates.permit(*model.bulky_attributes)
    end

    def update!
      model.attributes      = updates
      log.updatable_changes = model.changes
      model.save!
    rescue => e
      log.error_message   = e.message
      log.error_backtrace = e.backtrace.join("\n")
      raise e
    ensure
      log.save!
    end
  end
end
