require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    sign_in Factory.create(:user)
  end

  test "should get search" do
    Factory.create(:user, :first_name => "Perico")
    get :search, :q => "Perico"

    assert_response :success
    assert_not_nil assigns(:users)
  end

end
