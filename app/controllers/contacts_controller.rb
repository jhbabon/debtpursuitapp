class ContactsController < ApplicationController
  def index
    # TODO: pagination
    @contacts = current_user.contacts.order("first_name")
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new(:user => current_user)
  end

  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(@contact) }
      else
        format.html { render(:action => :new) }
      end
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(@contact) }
      else
        format.html { render(:action => :edit) }
      end
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy

    respond_to do |format|
      format.html { redirect_to(:action => :index) }
    end
  end
end
