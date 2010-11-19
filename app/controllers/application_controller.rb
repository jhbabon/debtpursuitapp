class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_tab
  before_filter :authenticate_user!

  layout :layout_by_resource


  protected

  # link:
  # http://rpheath.com/posts/304-tabbed-navigation-in-rails-refactored
  def set_current_tab
    @current_tab ||= controller_name.to_sym
  end

  def layout_by_resource
    if devise_controller? && !anybody_signed_in?
      'login'
    else
      'application'
    end
  end
end
