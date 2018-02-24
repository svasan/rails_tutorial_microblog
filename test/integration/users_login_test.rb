require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'login with invalid information' do
    get login_path
    assert_select 'form[action="/login"]'
    post login_path, params: { session: {email: "some@unknown.user", password: "abcdef"}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
