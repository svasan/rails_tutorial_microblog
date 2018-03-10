require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foobar)
  end

  test 'login with invalid information' do
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: { session: {email: "some@unknown.user", password: "abcdef"}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'valid login followed by logout' do
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: { session: {email: @user.email, password: "password"}}
    #    assert_template 'users/show'
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # No login
    assert_select "a[href=?]", login_path, count: 0
    assert is_logged_in?
    delete logout_path
    assert_not is_logged_in?
  end
end
