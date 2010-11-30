class BudgetsController < ApplicationController
  load_and_authorize_resource

  # GET /budgets
  def index
    @budgets = current_user.budgets.paginate(:page => params[:page])
  end

  # PUT /budgets/1
  def update
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
    respond_to do |format|
      @budget.update_attributes({ :paid => value })
      @contact = @budget.contact
      format.html { redirect_to(@contact) }
    end
  end
end
