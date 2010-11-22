require 'test_helper'

class DebtTest < ActiveSupport::TestCase
  test "should ensure amount" do
    debt = Factory.build(:debt, :amount => "9,99", :kind => "loan")
    assert debt.valid?
    assert_equal 9.99, debt.amount.to_f

    debt = Factory.build(:debt, :amount => "9'99", :kind => "loan")
    assert debt.valid?
    assert_equal 9.99, debt.amount.to_f

    debt = Factory.build(:debt, :amount => "9.99", :kind => "loan")
    assert debt.valid?
    assert_equal 9.99, debt.amount.to_f
  end

  test "should be negative if is a debt" do
    debt = Factory.build(:debt, :amount => "9,99", :kind => "debt")
    assert_equal -9.99, debt.amount.to_f

    debt = Factory.build(:debt, :amount => "9,99", :kind => "loan")
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

  test "should know his kind" do
    debt = Factory.create(:debt, :kind => "debt")
    assert debt.debt?
    assert !debt.loan?

    debt.update_attributes({ :kind => "loan" })
    assert !debt.debt?
    assert debt.loan?
  end
end
