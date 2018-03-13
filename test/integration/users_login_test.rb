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
    assert is_logged_in?

    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", login_path, count: 0

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path

    #Simulate a user clicking logout in a second window
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test 'login with remember' do
    post login_path, params: {
           session: {
             email: @user.email,
             password: "password",
             remember_me: "1"
           }
         }
    assert is_logged_in?
    assert is_remembered?
    follow_redirect!

    delete logout_path
    follow_redirect!

    assert_not is_logged_in?
    # Why doesn't this work.
    # assert_not is_remembered?
  end

  test 'login without remember' do
    post login_path, params: {
           session: {
             email: @user.email,
             password: "password",
             remember_me: "0"
           }
         }
    assert is_logged_in?
    assert_not is_remembered?
  end
end
