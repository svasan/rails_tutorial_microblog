require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user_foo = users(:foobar)
    @user_joe = users(:joe)
  end

  test 'unsuccessful edit' do
    log_in_as(@user_foo)
    get edit_user_path(@user_foo)
    assert_template 'users/edit'
    patch user_path(@user_foo), params: {
           user: {
             name: "",
             email: "invalid@email",
             password: "foo",
             password_confirmation: "bar"
           }
         }
    assert_template "users/edit"
    assert_select 'div.alert', "The form contains 4 errors"
  end

  test 'successful edit' do
    log_in_as(@user_foo)
    get edit_user_path(@user_foo)
    assert_template 'users/edit'
    name = "FooBar The Great"
    email = "foobar@thegreats.com"
    password = "foobar1234"
    patch user_path(@user_foo), params: {
           user: {
             name: name,
             email: email,
             password: password,
             password_confirmation: password
           }
          }
    assert_redirected_to @user_foo
    follow_redirect!
    assert_not flash.empty?
    @user_foo.reload
    assert_equal name, @user_foo.name
    assert_equal email, @user_foo.email
  end

  test 'edit before login should fail' do
    patch user_path(@user_foo), params: {
           user: {
             name: "Some Name",
             email: "valid@email.com",
             password: "password",
             password_confirmation: "password"
           }
          }
    assert_redirected_to login_url
    assert_not flash.empty?
  end

  test 'edit different user should redirect home' do
    log_in_as(@user_foo)
    get edit_user_path(@user_joe)
    assert_redirected_to root_url
  end

  test 'update different user should redirect home' do
    log_in_as(@user_foo)
    patch user_path(@user_joe), params: {
           user: {
             name: "Some Name",
             email: "valid@email.com",
             password: "password",
             password_confirmation: "password"
           }
          }
    assert_redirected_to root_url
  end

  test 'forward back to the original url after login' do
    get edit_user_path(@user_foo)
    log_in_as(@user_foo)
    assert_redirected_to edit_user_path(@user_foo)
  end
end
