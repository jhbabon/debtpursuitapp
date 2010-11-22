require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should have full name" do
    user = Factory.create(:user, :first_name => "Joe", :last_name => "Doe")

    assert_equal "Joe Doe", user.full_name
  end

  test "should get his total debt" do
    user = Factory.create(:user, :first_name => "Joe", :last_name => "Doe")
    budget1 = Factory.create(:budget, :user => user)
    1.upto(3) do |n|
      Factory.create(:debt, :budget => budget1, :amount => 1.1, :kind => "debt")
    end
    budget2 = Factory.create(:budget, :user => user)
    1.upto(2) do |n|
      Factory.create(:debt, :budget => budget2, :amount => 1.1, :kind => "loan")
    end

    assert_equal -1.1, user.total_debt
  end
end
