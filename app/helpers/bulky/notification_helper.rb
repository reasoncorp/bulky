module Bulky
  module NotificationHelper

    def bulky_notifications
      if Bulky::BulkUpdate.needs_notification.count > 0
        render 'bulky/bulk_updates/notification'
      end
    end
  end
end 
