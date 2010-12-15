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

  test "should not save if the users are friends" do
    sender = Factory.create(:user)
    receiver = Factory.create(:user)
    invitation = Factory.create(:invitation,
                                :sender => sender,
                                :receiver => receiver)
    invitation.accept
    invitation.destroy

    invitation = Factory.build(:invitation,
                               :sender => sender,
                               :receiver => receiver)

    assert_raise(Exceptions::Invitations::ContactExists) { invitation.save }
  end

  test "should not save if exists other invitation" do
    sender = Factory.create(:user)
    receiver = Factory.create(:user)
    invitation = Factory.create(:invitation,
                                :sender => sender,
                                :receiver => receiver)

    invitation = Factory.build(:invitation,
                               :sender => sender,
                               :receiver => receiver)
    assert_raise(Exceptions::Invitations::InvitationExists) { invitation.save }

    invitation = Factory.build(:invitation,
                               :sender => receiver,
                               :receiver => sender)
    assert_raise(Exceptions::Invitations::InvitationExists) { invitation.save }
  end
end
