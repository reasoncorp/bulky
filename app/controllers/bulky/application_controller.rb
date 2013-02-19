class Bulky::ApplicationController < ApplicationController

  private

  def model
    @model ||= params[:model].classify.constantize if params[:model]
  end
  helper_method :model
  
end
