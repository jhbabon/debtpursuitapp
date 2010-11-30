require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  def setup
    sign_in Factory.create(:user)
  end

  test "should get index if logged in" do
    get :index

    assert_response :success
  end

  test "should redirect if not logged in" do
    sign_out :user
    get :index

    assert_redirected_to new_user_session_path
  end

  test "should get license" do
    get :license

    assert_response :success
  end

  test "should get about" do
    get :about

    assert_response :success
  end

  test "should get contact" do
    get :contact

    assert_response :success
  end

end
