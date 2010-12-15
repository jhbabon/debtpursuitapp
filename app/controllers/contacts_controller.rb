class ContactsController < ApplicationController
  load_and_authorize_resource :except => [:select]

  def index
    @contacts = current_user.contacts.order("first_name")
    @contacts = @contacts.linked if params[:status] == "linked"
    @contacts = @contacts.unlinked if params[:status] == "unlinked"
    @contacts = @contacts.paginate(:page => params[:page])
  end

  def show
    @debts_all = Debt.shared_by(current_user, @contact.proxy).order("date DESC")
    @debts = @debts_all
    @debts = @debts.owed_by(current_user) if params[:type] == "debt"
    @debts = @debts.lent_by(current_user) if params[:type] == "loan"
    @debts = @debts.paid if params[:status] == "paid"
    @debts = @debts.unpaid if params[:status] == "unpaid"
    @debts = @debts.paginate(:page => params[:page])
  end

  def new
    @contact = Contact.new(:user => current_user)
  end

  def create
    respond_to do |format|
      if @contact.save
        format.html { redirect_to(@contact) }
      else
        format.html { render(:action => :new) }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(@contact) }
      else
        format.html { render(:action => :edit) }
      end
    end
  end

  def select
    authorize! :create, Contact
  end

  def destroy
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(:action => :index) }
    end
  end
end
