class HomeController < ApplicationController
  def index
    @debts = Debt.owned_by(current_user).uncleared.recent
  end

  def license
    draft
  end

  def about
    draft
  end

  protected

  def draft
    respond_to do |format|
      format.html { render :template => "home/draft" }
    end
  end

end
