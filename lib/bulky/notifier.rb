module Bulky
  module Notifier
   
    def self.included(klass)
      klass.before_filter :bulky_notifications
    end
    
    def bulky_notifications
      if Bulky::BulkUpdate.belongs_to_user(bulky_user_id).needs_notification.any?
        flash.now[:notice] = %Q[<a href="/bulky/admin">Bulk Update Notifications</a>].html_safe if flash[:notice].nil?
      end
    end

    def bulky_user_id
      current_user.id rescue nil
    end

  end
end

