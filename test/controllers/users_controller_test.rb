require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user_foo = users(:foobar)
    @user_joe = users(:joe)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "index should redirect when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "admin attribute cannot be set" do
    log_in_as(@user_joe)
    assert_not @user_joe.admin?
    patch user_path(@user_joe), params: {
      user: {
        password: "otherpass",
        password_confirmation: "otherpass",
        admin: true
      }
    }
    assert_not @user_joe.reload.admin?
  end
end
