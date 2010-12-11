require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  def setup
    @user = Factory.create(:user)
    @contact = Factory.create(:contact, :user => @user)
    sign_in @user
  end

  test "should get index" do
    get :index

    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should ge contact" do
    get :show, :id => @contact.to_param

    assert_response :success
    assert_not_nil assigns(:contact)
  end

  test "should get new" do
    get :new

    assert_response :success
    assert_not_nil assigns(:contact)
  end

  test "should create contact" do
    post :create,
         :contact => @contact.attributes.reject { |key, value|
                       [:created_at, :updated_at].include?(key)
                     }

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should not create contact" do
    post :create,
         :contact => { :email => "",
                       :first_name => "",
                       :last_name => "" }

    assert_template "new"
  end

  test "should get edit" do
    get :edit, :id => @contact.to_param

    assert_response :success
    assert_not_nil assigns(:contact)
  end

  test "should update contact" do
    put :update,
        :id => @contact.to_param,
        :contact => Factory.build(:contact).attributes.reject { |key, value|
                       [:created_at, :updated_at].include?(key)
                     }
    assert_redirected_to contact_path(@contact)
  end

  test "should not update contact" do
    put :update,
        :id => @contact.to_param,
        :contact => { :email => "",
                      :first_name => "",
                      :last_name => "" }

    assert_template "edit"
  end

  test "should destroy contact" do
    delete :destroy, :id => @contact.to_param

    assert_redirected_to contacts_path
  end

  test "should get select" do
    get :select

    assert_response :success
  end
end
