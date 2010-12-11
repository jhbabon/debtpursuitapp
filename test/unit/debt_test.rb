require 'test_helper'

class DebtTest < ActiveSupport::TestCase
  test "should ensure amount" do
    debt = Factory.build(:debt, :amount => "9,99")
    assert debt.valid?
    assert_equal 9.99, debt.amount.to_f

    debt = Factory.build(:debt, :amount => "9'99")
    assert debt.valid?
    assert_equal 9.99, debt.amount.to_f

    debt = Factory.build(:debt, :amount => "9.99")
    assert debt.valid?
    assert_equal 9.99, debt.amount.to_f
  end

  test "should use today if do not have date" do
    debt = Factory.create(:debt)
    assert_equal Date.today.strftime("%Y-%m-%d"), debt.date.to_s

    debt = Factory.create(:debt, :date => Date.yesterday)
    assert_not_equal Date.today.strftime("%Y-%m-%d"), debt.date.to_s
    assert_equal Date.yesterday.to_s, debt.date.to_s
  end

  test "should get paid" do
    debt = Factory.create(:debt)

    assert debt.update_attributes({ :paid => true })
    assert debt.paid?

    assert debt.update_attributes({ :paid => false })
    assert !debt.paid?
  end

  test "should get debts from person" do
    user = Factory.create(:user)
    1.upto(2) { Factory.create(:debt, :debtor => user) }
    1.upto(2) { Factory.create(:debt, :lender => user) }
    Factory.create(:debt)

    assert_equal 2, Debt.owed_by(user).count
    assert_equal 2, Debt.lent_by(user).count
    assert_equal 4, Debt.owned_by(user).count

    contact = Factory.create(:contact)
    1.upto(2) { Factory.create(:debt, :debtor => contact) }
    1.upto(2) { Factory.create(:debt, :lender => contact) }
    Factory.create(:debt)

    assert_equal 2, Debt.owed_by(contact).count
    assert_equal 2, Debt.lent_by(contact).count
    assert_equal 4, Debt.owned_by(contact).count
  end

  test "should get shared debts from persons" do
    user1 = Factory.create(:user)
    user2 = Factory.create(:user)
    contact = Factory.create(:contact)
    1.upto(2) { Factory.create(:debt, :debtor => user1, :lender => user2) }
    1.upto(2) { Factory.create(:debt, :lender => user1, :debtor => user2) }
    Factory.create(:debt, :debtor => user1, :lender => contact)
    Factory.create(:debt, :debtor => contact, :lender => user2)

    assert_equal 4, Debt.shared_by(user1, user2).count
    assert_equal 1, Debt.shared_by(user1, contact).count
    assert_equal 1, Debt.shared_by(user2, contact).count
  end

  test "should get partner" do
    user = Factory.create(:user)
    contact = Factory.create(:contact)
    debt = Factory.create(:debt, :debtor => user, :lender => contact)

    assert_equal user, debt.partner(contact.proxy)
    assert_equal contact.proxy, debt.partner(user)
  end

  test "should know his type" do
    user = Factory.create(:user)
    contact = Factory.create(:contact)
    debt = Factory.create(:debt, :debtor => user, :lender => contact)

    assert_equal 'debt', debt.type(user)
    assert_equal 'loan', debt.type(contact.proxy)
  end

  test "should check if is debt or loan" do
    user = Factory.create(:user)
    contact = Factory.create(:contact)
    debt = Factory.create(:debt, :debtor => user, :lender => contact)

    assert debt.debt?(user)
    assert debt.loan?(contact.proxy)
  end

  test "should get debtor and lender from his polymorphic id" do
    debtor = Factory.create(:user)
    lender = Factory.create(:contact)
    debt = Factory.build(:debt,
                         :debtor => nil,
                         :lender => nil,
                         :debtor_str => debtor.polymorphic_id,
                         :lender_str => lender.polymorphic_id)

    assert debt.valid?
    assert_equal debtor, debt.debtor
    assert_equal lender, debt.lender
    assert_equal debtor.polymorphic_id, debt.debtor_str
    assert_equal lender.polymorphic_id, debt.lender_str
  end
end
