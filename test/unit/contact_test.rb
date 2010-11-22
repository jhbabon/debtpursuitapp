require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test "should create budget when create" do
    contact = Factory.create(:contact)

    assert_not_nil contact.budget
  end
end
