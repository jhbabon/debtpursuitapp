require 'test_helper'

class DebtsControllerTest < ActionController::TestCase
  setup do
    @user = Factory.create(:user)
    @contact = Factory.create(:contact, :user => @user)
    @budget = Factory.create(:budget, :user => @user, :contact => @contact)
    @debt = Factory.create(:debt, :budget => @budget)
    sign_in @user
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create debt" do
    post :create,
         :debt => @debt.attributes.reject { |key, value|
                     [:created_at, :updated_at].include?(key)
                   }

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should not create debt" do
    post :create,
         :debt => { :amount => "", :budget_id => "" }

    assert_template "new"
  end

  test "should get edit" do
    get :edit, :id => @debt.to_param

    assert_response :success
  end

  test "should update debt" do
    put :update,
        :id => @debt.to_param,
        :debt => @debt.attributes.reject { |key, value|
                    [:created_at, :updated_at].include?(key)
                  }

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should not update debt" do
    put :update,
        :id => @debt.to_param,
        :debt => { :amount => "" }

    assert_template "edit"
  end

  test "should destroy debt" do
    delete :destroy, :id => @debt.to_param

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should pay debt" do
    put :pay, :id => @debt.to_param

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should unpay debt" do
    put :unpay, :id => @debt.to_param

    assert_redirected_to contact_path(assigns(:contact))
  end
end
