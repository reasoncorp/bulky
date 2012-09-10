class Bulky::UpdatesController < ApplicationController

  helper_method :model

  def edit
  end

  def update
  end

  private

  def model
    @model ||= params[:model].classify.constantize
  end

end
