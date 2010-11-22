require 'test_helper'

class BudgetsControllerTest < ActionController::TestCase
  setup do
    @user = Factory.create(:user)
    @contact = Factory.create(:contact, :user => @user)
    @budget = Factory.create(:budget, :user => @user, :contact => @contact)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:budgets)
  end

  test "should update budget" do
    put :update, :id => @budget.to_param, :budget => { :paid => "1" }
    assert_redirected_to budget_path(assigns(:budget))
  end

  test "should pay budget" do
    put :pay, :id => @budget.to_param

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should unpay budget" do
    put :unpay, :id => @budget.to_param

    assert_redirected_to contact_path(assigns(:contact))
  end
end
