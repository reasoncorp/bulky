class Bulky::UpdatesController < Bulky::ApplicationController

  def edit
    render "edit_#{model.name.downcase}"
  end

  def update
    if params[:ids].blank?
      redirect_to bulky_edit_path(model: params[:model]), alert: I18n.t('flash.alert.blank_ids') and return
    end

    unless params[:bulk].is_a?(Hash)
      redirect_to bulky_edit_path(model: params[:model]), alert: I18n.t('flash.alert.bulk_not_hash') and return
    end

    Bulky.enqueue_update(model, ids, params[:bulk], bulky_user_id)
    redirect_to bulky_edit_path(model: params[:model]), notice: I18n.t('flash.notice.enqueue_update')
  end

  private

  def ids
    Bulky.parse_ids(params[:ids])
  end

  def params
    @params ||= delete_blank(super)
  end

  def delete_blank(hash)
    hash.delete_if { |k,v| v.empty? or Hash === v && delete_blank(v).empty? }
  end

end
