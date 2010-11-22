class BudgetsController < ApplicationController
  # GET /budgets
  def index
    @budgets = current_user.budgets

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # PUT /budgets/1
  def update
    @budget = Budget.find(params[:id])

    respond_to do |format|
      if @budget.update_attributes(params[:budget])
        format.html { redirect_to(@budget, :notice => 'budget was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # PUT /budgets/1/pay
  def pay
    pay_budget
  end

  # PUT /budgets/1/unpay
  def unpay
    pay_budget false
  end

  protected

  def pay_budget(value=true)
    @budget = Budget.find(params[:id])
    respond_to do |format|
      @budget.update_attributes({ :paid => value })
      @contact = @budget.contact
      format.html { redirect_to(@contact) }
    end
  end
end
