require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:foobar)
  end

  test 'unsuccessful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
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
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "FooBar The Great"
    email = "foobar@thegreats.com"
    password = "foobar1234"
    patch user_path(@user), params: {
           user: {
             name: name,
             email: email,
             password: password,
             password_confirmation: password
           }
          }
    assert_redirected_to @user
    follow_redirect!
    assert_not flash.empty?
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
