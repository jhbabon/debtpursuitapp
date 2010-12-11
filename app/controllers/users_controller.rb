class UsersController < ApplicationController
  def search
    @users = params[:q].blank? ? [] : User.search(params[:q]).order("first_name")
    @users = @users.paginate(:page => params[:page])
  end

  protected

  def set_current_tab
    @current_tab = :contacts
  end

end
