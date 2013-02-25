module Bulky
  class Updater

    def self.perform(model_name, update_id, bulk_update_id)
      model = model_name.constantize.find(update_id)
      new(model, bulk_update_id).update!
    end

    def initialize(model, bulk_update_id)
      @bulk_update = Bulky::BulkUpdate.find(bulk_update_id)
      @model       = model
      @updates     = @bulk_update.updates
    end

    def update!
      @model.tap do
        @log = @bulk_update.updated_records.build { |r| r.updatable = @model }

        begin
          @model.attributes = @updates
          @log.updatable_changes = @model.changes
          @model.save!
        rescue => e
          @log.error_message   = e.message
          @log.error_backtrace = e.backtrace.join("\n")
          raise e
        ensure
          @log.completed = true
          @log.save!
        end
      end
    end

  end
end
