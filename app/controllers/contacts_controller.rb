class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
    # TODO: pagination
    @contacts = @contacts.order("first_name")
  end

  def show
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

  def destroy
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(:action => :index) }
    end
  end
end
