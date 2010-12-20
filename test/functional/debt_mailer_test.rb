require 'test_helper'

class DebtMailerTest < ActionMailer::TestCase
  test "notification email" do
    user = Factory.create(:user)
    friend = Factory.create(:user)
    debt = Factory.create(:debt, :debtor => user, :lender => friend)

    %w(created updated deleted paid unpaid).each do |action|
      email = DebtMailer.notification_email(friend, debt, action).deliver

      assert !ActionMailer::Base.deliveries.empty?
      assert_equal [friend.email], email.to
    end
  end
end
