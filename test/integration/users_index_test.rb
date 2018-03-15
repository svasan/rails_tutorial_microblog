require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:foobar)
    @user_joe = users(:joe)
  end

  test "index including pagination" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", count: 2
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      unless @admin == user
        assert_select "a[href=?]", user_path(user), text: "delete", count: 1
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@user_joe)
    end
  end

  test "index as non-admin" do
    log_in_as(@user_joe)
    get users_path
    assert_select "a", text: "delete", count: 0
  end
end
