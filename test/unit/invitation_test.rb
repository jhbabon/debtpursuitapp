require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  test "should create contacts when is accepted" do
    sender = Factory.create(:user)
    receiver = Factory.create(:user)
    invitation = Factory.create(:invitation,
                                :sender => sender,
                                :receiver => receiver)

    contacts_num = Contact.all.count
    sender_contacts = sender.contacts.count
    receiver_contacts = receiver.contacts.count

    contact = invitation.accept

    assert_equal sender.full_name, contact.full_name
    assert_equal sender.email, contact.email
    assert_equal contacts_num + 2, Contact.all.count
    assert_equal sender_contacts + 1, sender.contacts.count
    assert_equal receiver_contacts + 1, receiver.contacts.count
  end
end
