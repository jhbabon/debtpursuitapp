require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index if logged in" do
    sign_in Factory.create(:user)
    get :index

    assert_response :success
  end

  test "should redirect if not logged in" do
    sign_out :user
    get :index

    assert_redirected_to new_user_session_path
  end

end
