require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup should fail' do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: 'Some Name',
                                          email: 'invalid@email',
                                          password: 'abcdef',
                                          password_confirmation: 'abcdef'}}
    end
    assert_select 'div#error_explanation'
    assert_select 'div.alert', "The form contains 2 errors"
    assert_select 'div.field_with_errors input', 2
    assert_template 'users/new'
  end

  test 'valid signup' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Some Name',
                                          email: 'valid@email.com',
                                          password: 'abcdefgh',
                                          password_confirmation: 'abcdefgh'}}
    end
    follow_redirect!
    assert_select 'div.alert-success'
    # assert_template 'users/show'
    assert flash[:success]
    # assert is_logged_in?
  end

  test "valid sign up with account activation" do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Some Name',
                                          email: 'valid@email.com',
                                          password: 'abcdefgh',
                                          password_confirmation: 'abcdefgh'}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    log_in_as(user)
    assert_not is_logged_in?

    get edit_account_activation_url("random token", email: user.email)
    assert_not is_logged_in?

    get edit_account_activation_url(user.activation_token, email: "some@random.email")
    assert_not is_logged_in?

    get edit_account_activation_url(user.activation_token, email: user.email)
    assert is_logged_in?
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
  end
end
