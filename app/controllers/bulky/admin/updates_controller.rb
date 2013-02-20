class Bulky::Admin::UpdatesController < Bulky::ApplicationController

  layout 'bulky'

  def index
    bulk_updates
  end

  def show
    bulk_update.mark_as_notified
  end

  def retry
    model = OpenStruct.new(name: bulk_update.updated_records.first.updatable_type)
    ids = bulk_update.ids
    updates = bulk_update.updates
    user_id = current_user.id
    Bulky.enqueue_update(model, ids, updates, current_user.id)
    bulk_update.mark_as_notified
    redirect_to bulky_index_path(model: params[:model]), notice: I18n.t('flash.notice.enqueue_retry')
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

end
