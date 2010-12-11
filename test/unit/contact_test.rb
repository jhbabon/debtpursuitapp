require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test "should act as proxy when have friend" do
    friend = Factory.create(:user)
    contact = Factory.create(:contact, :friend => friend)

    assert_equal friend.email, contact.email
    assert_equal friend.first_name, contact.first_name
    assert_equal friend.last_name, contact.last_name
    assert_equal friend.full_name, contact.full_name
  end

  test "should return friend if act as proxy" do
    friend = Factory.create(:user)
    contact = Factory.create(:contact, :friend => friend)

    assert_equal friend, contact.proxy
  end

  test "should return self if don't have friend'" do
    contact = Factory.create(:contact, :friend => nil)

    assert_equal contact, contact.proxy
  end

  test "should find contact if have the user who is friend" do
    friend = Factory.create(:user)
    contact = Factory.create(:contact, :friend => friend)

    assert_equal contact, Contact.reverse_proxy(friend)
  end

  test "should return contact when search for the proxy" do
    friend = Factory.create(:user)
    contact = Factory.create(:contact, :friend => friend)

    assert_equal contact, Contact.reverse_proxy(contact)
  end

  test "should get polymorphic id" do
    contact = Factory.create(:contact)

    assert_equal "#{contact.id}_#{contact.class.to_s}", contact.polymorphic_id
  end

  test "should keep shared debts for friend when destroy" do
    user = Factory.create(:user)
    friend = Factory.create(:user)
    contact1 = Factory.create(:contact, :user => user, :friend => friend)
    contact2 = Factory.create(:contact, :user => friend, :friend => user)
    Factory.create(:debt, :debtor => user, :lender => friend)
    Factory.create(:debt, :debtor => friend, :lender => user)

    contact1.destroy
    contact2.reload
    assert_equal 0, Debt.shared_by(user, friend).count
    assert_equal 0, Debt.owned_by(user).count
    assert_equal 2, Debt.shared_by(contact2.proxy, friend).count
    assert_equal 2, Debt.owned_by(friend).count
    assert_equal 2, Debt.owned_by(contact2.proxy).count
  end

  test "should destroy all debts if don't have friend" do
    user = Factory.create(:user)
    contact = Factory.create(:contact, :user => user)
    Factory.create(:debt, :debtor => user, :lender => contact)
    Factory.create(:debt, :debtor => contact, :lender => user)

    contact.destroy
    assert_equal 0, Debt.shared_by(user, contact.proxy).count
    assert_equal 0, Debt.all.count
  end

  test "should know if is a proxy" do
    contact = Factory.create(:contact, :friend => Factory.create(:user))
    assert contact.proxy?

    contact = Factory.create(:contact, :friend => nil)
    assert !contact.proxy?
  end
end
