class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'

  # return: the sender contact
  def accept
    # contact for the sender
    Contact.create(:friend => receiver,
                   :user => sender)

    # contact for the receiver
    Contact.create(:friend => sender,
                   :user => receiver)
  end
end
