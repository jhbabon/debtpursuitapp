class Invitation < ActiveRecord::Base
  before_create :is_necessary?

  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'

  scope :recent, limit(5).order("created_at DESC")

  # return: the sender contact
  def accept
    # contact for the sender
    Contact.create(:friend => receiver,
                   :user => sender)

    # contact for the receiver
    Contact.create(:friend => sender,
                   :user => receiver)
  end

  protected

  def is_necessary?
    if Contact.reverse_proxy(User.find(self.receiver_id))
      raise Exceptions::Invitations::ContactExists
    end

    if Invitation.where(:sender_id => self.sender_id, :receiver_id => self.receiver_id).first ||
       Invitation.where(:sender_id => self.receiver_id, :receiver_id => self.sender_id).first
      raise Exceptions::Invitations::InvitationExists
    end
  end
end
