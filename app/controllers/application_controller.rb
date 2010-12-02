class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_tab
  before_filter :authenticate_user!
  before_filter :set_locale

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end


  protected

  # link:
  # http://rpheath.com/posts/304-tabbed-navigation-in-rails-refactored
  def set_current_tab
    @current_tab ||= controller_name.to_sym
  end

  def set_locale
    I18n.locale = anybody_signed_in? ? current_user.locale : "en"
  end

  def layout_by_resource
    if devise_controller? && !anybody_signed_in?
      'login'
    else
      'application'
    end
  end
end
