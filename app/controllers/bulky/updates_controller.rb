class Bulky::UpdatesController < ApplicationController

  helper_method :model

  def edit
  end

  def update
    if params[:ids].blank?
      redirect_to bulky_edit_path(model: params[:model]), alert: I18n.t('flash.alert.blank_ids') and return
    end

    unless params[:bulk].is_a?(Hash)
      redirect_to bulky_edit_path(model: params[:model]), alert: I18n.t('flash.alert.bulk_not_hash') and return
    end

    Bulky.enqueue_update(model, ids, params[:bulk])
    redirect_to bulky_edit_path(model: params[:model]), notice: I18n.t('flash.notice.enqueue_update')
  end

  def params
    @params ||= delete_blank(super)
  end

  private

  helper_method def model_name
    params.require(:model)
  end

  def model
    @model ||= model_name.classify.constantize
  end
  
  def ids
    Bulky.parse_ids(params[:ids])
  end

  def delete_blank(hash)
    hash.delete_if { |k,v| v.empty? or Hash === v && delete_blank(v).empty? }
  end

end
