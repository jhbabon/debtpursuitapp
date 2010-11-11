class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller? && !anybody_signed_in?
      'login'
    else
      'application'
    end
  end
end
