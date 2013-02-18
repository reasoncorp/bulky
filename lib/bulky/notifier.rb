module Bulky
  module Notifier
    
    def self.included(klass)
      klass.before_filter :bulky_notifications
    end
    
    def bulky_notifications
      if Bulky::BulkUpdate.belongs_to_user(current_user.id).needs_notification.any?
        flash.now[:notice] = %Q[<a href="/bulky">Bulk Update Notifications</a>].html_safe
      end
    end

    def bulky_hide_notifications
      @notifications = Bulky::BulkUpdate.needs_notification
    end

  end
end

