class Bulky::UpdatesController < ApplicationController

  def edit
    render "edit_#{model}"
  end

  def update
    if params[:ids].blank?
      redirect_to bulky_edit_path(model: params[:model]), alert: I18n.t('flash.alert.blank_ids') and return
    end

    unless params[:bulk].is_a?(Hash)
      redirect_to bulky_edit_path(model: params[:model]), alert: I18n.t('flash.alert.bulk_not_hash') and return
    end

    Bulky.enqueue_update(model, ids, params[:bulk], current_user.id)
    redirect_to bulky_edit_path(model: params[:model]), notice: I18n.t('flash.notice.enqueue_update')
  end

  private

  def model
    @model ||= params[:model].classify.constantize if params[:model]
  end
  helper_method :model
  
  def ids
    Bulky.parse_ids(params[:ids])
  end

  def bulk_updates
    @bulk_updates ||= Bulky::BulkUpdate.all
  end
  helper_method :bulk_updates

  def bulk_update
    @bulk_update ||= Bulky::BulkUpdate.find(params[:id])
  end
  helper_method :bulk_update

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
