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
    redirect_to bulky_edit_path(model: params[:model]), notice: I18n.t('flash.notice.update_enqueue')
  end

  private

  def model
    @model ||= params[:model].classify.constantize
  end
  
  def ids
    Bulky.parse_ids(params[:ids])
  end

end
