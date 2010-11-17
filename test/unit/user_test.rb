require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should have full name" do
    user = Factory.create(:user, :first_name => "Joe", :last_name => "Doe")

    assert_equal "Joe Doe", user.full_name
  end
end
