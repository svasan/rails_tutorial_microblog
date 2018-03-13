require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  def is_logged_in?
    session.has_key?(:user_id)
  end

  def remembered?
    # Turns out it could be nil or empty depending on the flow
    !(cookies[:remember_token].nil? || cookies[:remember_token].empty?) &&
      !(cookies[:user_id].nil? || cookies[:user_id].empty?)
  end

end

class ActionDispatch::IntegrationTest

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: {
           session: {
             email: user.email,
             password: password,
             remember_me: remember_me
           }
         }
  end
end
