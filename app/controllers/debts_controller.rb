class DebtsController < ApplicationController
  load_and_authorize_resource

  def index
    @debts_all = Debt.owned_by(current_user).order("date DESC")
    @debts = @debts_all
    @debts = @debts.owed_by(current_user) if params[:type] == "debt"
    @debts = @debts.lent_by(current_user) if params[:type] == "loan"
    @debts = @debts.paid if params[:status] == "paid"
    @debts = @debts.unpaid if params[:status] == "unpaid"
    @debts = @debts.paginate(:page => params[:page])
  end

  def show
  end

  # GET /debts/new
  def new
    respond_to do |format|
      if current_user.contacts.empty?
        format.html { redirect_to(select_contacts_path, :alert => I18n.t("views.debts.flash.create_contact")) }
      else
        format.html # new.html.erb
      end
    end
  end

  # GET /debts/1/edit
  def edit
  end

  # POST /debts
  def create
    respond_to do |format|
      if @debt.save
        format.html { redirect_to(@debt) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /debts/1
  def update
    respond_to do |format|
      if @debt.update_attributes(params[:debt])
        @contact = Contact.reverse_proxy(@debt.partner(current_user))
        format.html { redirect_to(@debt) }
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
    @contact = Contact.reverse_proxy(@debt.partner(current_user))
    @debt.destroy

    respond_to do |format|
      format.html { redirect_to(@contact) }
    end
  end

  protected

  def pay_debt(value=true)
    respond_to do |format|
      @debt.update_attributes({ :paid => value })
      @contact = Contact.reverse_proxy(@debt.partner(current_user))
      format.html { redirect_to(@debt) }
    end
  end
end
