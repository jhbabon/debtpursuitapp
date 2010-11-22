require 'test_helper'


class BudgetTest < ActiveSupport::TestCase

  test "should get paid and unpaid" do
    budget = Factory.create(:budget)
    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :paid => false)
    end
    Factory.create(:debt, :budget => budget, :paid => true)
    budget.reload

    assert !budget.paid?

    assert budget.update_attributes({ :paid => true })
    assert budget.paid?
    budget.debts.each do |debt|
      assert debt.paid?
    end

    assert budget.update_attributes({ :paid => false })
    assert !budget.paid?
    budget.debts.each do |debt|
      assert !debt.paid?
    end
  end

  test "should be paid if total is 0" do
    budget = Factory.create(:budget)
    assert_equal 0, budget.total

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "debt")
    end
    budget.reload
    assert !budget.paid?

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "loan")
    end
    budget.reload
    assert budget.paid?
  end

  test "should get total debt" do
    budget = Factory.create(:budget)
    assert_equal 0, budget.total

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "debt")
    end
    Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "debt", :paid => true)
    Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "loan")
    budget.reload
    assert_equal -3.3, budget.total_debt
  end

  test "should get total loan" do
    budget = Factory.create(:budget)
    assert_equal 0, budget.total

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "loan")
    end
    Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "loan", :paid => true)
    Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "debt")
    budget.reload
    assert_equal 3.3, budget.total_loan
  end

  test "should get total" do
    budget = Factory.create(:budget)
    assert_equal 0, budget.total

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "debt")
    end
    budget.reload
    assert_equal -3.3, budget.total

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "loan")
    end
    budget.reload
    assert_equal 0, budget.total

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "debt", :paid => true)
    end
    budget.reload
    assert_equal 0, budget.total

    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget, :amount => 1.1, :kind => "loan")
    end
    budget.reload
    assert_equal 3.3, budget.total
  end
end
