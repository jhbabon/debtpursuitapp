class HomeController < ApplicationController
  def index
    @new_debt = Debt.new
    @debts = Debt.order("updated_at DESC").limit(5).all
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
