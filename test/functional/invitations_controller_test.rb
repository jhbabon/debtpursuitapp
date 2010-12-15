require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  setup do
    @user = Factory.create(:user)
    @invitation = Factory.create(:invitation, :receiver => @user)
    sign_in @user
  end

  test "should get index" do
    get :index

    assert_response :success
    assert_not_nil assigns(:invitations)
  end

  test "should create invitation" do
    post :create, :invitation => Factory.build(:invitation, :sender => @user).attributes

    assert_redirected_to contacts_path
  end

  test "should accept invitation" do
    put :accept, :id => @invitation.to_param

    assert_redirected_to contact_path(assigns(:contact))
  end

  test "should destroy invitation" do
    delete :destroy, :id => @invitation.to_param

    assert_redirected_to invitations_path
  end

  test "should rescue from existence of contact" do
    @invitation.accept
    post :create, :invitation => Factory.build(:invitation,
                                               :sender => @invitation.sender,
                                               :receiver => @invitation.receiver).attributes

    assert_redirected_to contacts_path
    assert flash[:alert]
  end

  test "should rescue from existence of invitation" do
    post :create, :invitation => Factory.build(:invitation,
                                               :sender => @invitation.sender,
                                               :receiver => @invitation.receiver).attributes

    assert_redirected_to contacts_path
    assert flash[:alert]
  end
end
