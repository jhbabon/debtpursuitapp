require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should have full name" do
    user = Factory.create(:user, :first_name => "Joe", :last_name => "Doe")

    assert_equal "Joe Doe", user.full_name
  end

  test "should search users by first name, last name or full name" do
    Factory.create(:user, :first_name => "First")
    Factory.create(:user, :last_name => "Last")
    Factory.create(:user, :first_name => "Unique", :last_name => "Name")

    users = User.search("First")
    assert_equal 1, users.count
    users = User.search("Firs")
    assert_equal 1, users.count

    users = User.search("Last")
    assert_equal 1, users.count
    users = User.search("ast")
    assert_equal 1, users.count

    users = User.search("Unique Name")
    assert_equal 1, users.count
    users = User.search("Unique Na")
    assert_equal 1, users.count
  end

  test "should get polymorphic id" do
    user = Factory.create(:user)

    assert_equal "#{user.id}_#{user.class.to_s}", user.polymorphic_id
  end
end
