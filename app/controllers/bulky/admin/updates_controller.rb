class Bulky::Admin::UpdatesController < Bulky::ApplicationController

  layout 'bulky'

  def index
  end

  def show
    bulk_update.mark_as_notified!
  end

  def retry
    begin
      Bulky::Updater.perform(update_record.updatable_type, update_record.updatable_id, update_record.bulk_update_id)
    rescue
      redirect_to bulky_show_path(update_record.bulk_update_id), notice: I18n.t('flash.notice.enqueue_retry')
    end
  end

  private

  def bulk_updates
    @bulk_updates ||= Bulky::BulkUpdate.all
  end
  helper_method :bulk_updates

  def bulk_update
    @bulk_update ||= Bulky::BulkUpdate.find(params[:id])
  end
  helper_method :bulk_update

  def update_record
    @update_record ||= Bulky::UpdatedRecord.find(params[:id])
  end
end
