require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  # include ApplicationHelper

  def setup
    @user_foo = users(:foobar)
  end

  test "user profile display" do
    get user_path(@user_foo)
    assert_template 'users/show'
    assert_select 'title', full_title(@user_foo.name)

    assert_select 'h1', text: @user_foo.name
    assert_select 'h1>img.gravatar'
    assert_select 'div.stats'
    assert_match 'followers', response.body
    assert_match 'following', response.body
    assert_match "Microposts (#{@user_foo.microposts.count})", response.body
    assert_select "div.pagination", count: 1
    @user_foo.microposts.paginate(page: 1).each do |post|
      # html escape content as that is how the response body
      # is. Otherwise 's esp won't match.
      assert_match ERB::Util.html_escape(post.content), response.body
    end
  end
end
