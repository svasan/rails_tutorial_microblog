require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "index should redirect when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
end
