class HomeController < ApplicationController
  def index
    @debts = Debt.owned_by(current_user).unpaid.recent
    @invitations = current_user.received_invitations.recent
  end

  def license; end
end
