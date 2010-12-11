class InvitationsController < ApplicationController
  # GET /invitations
  def index
    @invitations = current_user.received_invitations.order("created_at DESC").paginate(:page => params[:page])
  end

  # POST /invitations
  def create
    @invitation = Invitation.new(params[:invitation])

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to(contacts_path, :notice => I18n.t("views.invitations.flash.sended")) }
      else
        format.html { redirect_to(contacts_path, :alert => I18n.t("views.invitations.flash.error")) }
      end
    end
  end

  # PUT /invitations/:id/accept
  def accept
    @invitation = current_user.received_invitations.find(params[:id])
    @contact = @invitation.accept
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(@contact) }
    end
  end

  # DELETE /invitations/1
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(invitations_path) }
    end
  end

  protected

  def set_current_tab
    @current_tab = :contacts
  end
end
