require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @user = Factory.create(:user)
    @debt = Factory.create(:debt, :debtor => @user)
    @comment = Factory.create(:comment, :debt => @debt, :user => @user)
    sign_in @user
  end

  test "should create comment" do
    post :create,
         :comment => @comment.attributes.reject { |key, value|
                       [:created_at, :updated_at].include?(key)
                     }

    assert_redirected_to debt_path(assigns(:debt))
  end
end
