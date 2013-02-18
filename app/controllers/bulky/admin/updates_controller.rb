class Bulky::Admin::UpdatesController < ApplicationController

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

  def model
    @model ||= params[:model].classify.constantize if params[:model]
  end
  helper_method :model
  
  def ids
    Bulky.parse_ids(params[:ids])
  end

  def params
    @params ||= delete_blank(super)
  end

  def delete_blank(hash)
    hash.delete_if { |k,v| v.empty? or Hash === v && delete_blank(v).empty? }
  end

  def user_id
    current_user.id rescue nil
  end

end
