class HomeController < ApplicationController
  def index
    @new_debt = Debt.new
    @debts = Debt.order("updated_at DESC").limit(5).all
  end

end
