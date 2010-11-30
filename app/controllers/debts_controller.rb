class DebtsController < ApplicationController
  load_and_authorize_resource

  # GET /debts/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /debts/1/edit
  def edit
  end

  # POST /debts
  def create
    respond_to do |format|
      if @debt.save
        @contact = @debt.budget.contact
        format.html { redirect_to(@contact) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /debts/1
  def update
    respond_to do |format|
      if @debt.update_attributes(params[:debt])
        @contact = @debt.budget.contact
        format.html { redirect_to(@contact) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # PUT /debts/1/pay
  def pay
    pay_debt
  end

  # PUT /debts/1/unpay
  def unpay
    pay_debt false
  end

  # DELETE /debts/1
  def destroy
    @contact = @debt.budget.contact
    @debt.destroy

    respond_to do |format|
      format.html { redirect_to(@contact) }
    end
  end

  protected

  def pay_debt(value=true)
    respond_to do |format|
      @debt.update_attributes({ :paid => value })
      @contact = @debt.budget.contact
      format.html { redirect_to(@contact) }
    end
  end
end
