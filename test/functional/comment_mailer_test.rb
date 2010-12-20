require 'test_helper'

class CommentMailerTest < ActionMailer::TestCase
  test "new comment email" do
    user = Factory.create(:user)
    friend = Factory.create(:user)
    debt = Factory.create(:debt, :debtor => user, :lender => friend)
    comment = Factory.create(:comment, :debt => debt, :user => user)

    email = CommentMailer.new_comment_email(friend, comment).deliver

    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [friend.email], email.to
  end
end
