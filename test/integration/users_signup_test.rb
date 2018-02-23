require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
end
