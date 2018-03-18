require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user_foo = users(:foobar)
    log_in_as(@user_foo)
  end

  test 'profile user info' do
    get following_user_path(@user_foo)

    assert_match @user_foo.name, response.body
    assert_match "#{@user_foo.microposts.count} microposts", response.body
  end

  test "following" do
    get following_user_path(@user_foo)

    assert_match @user_foo.following.count.to_s, response.body
    assert_select 'section.user_avatars', count: 1
    assert_select 'ul.users', count: 1
    assert_select "h3", text: "Following"
    @user_foo.following.each do |user|
      assert_match user.name, response.body
      assert_select "a[href=?]", user_path(user)
    end
  end

  test 'no following' do
    user = users(:user_20)
    get following_user_path(user)
    assert_match user.name, response.body
    assert_select "h3", text: "Following"
    assert_select 'section.user_avatars', count: 0
    assert_select 'ul.users', count: 0
  end

  test "followers" do
    get followers_user_path(@user_foo)

    assert_match @user_foo.followers.count.to_s, response.body
    assert_select "h3", text: "Followers"
    assert_select 'section.user_avatars', count: 1
    assert_select 'ul.users', count: 1
    @user_foo.followers.each do |user|
      assert_match user.name, response.body
      assert_select "a[href=?]", user_path(user)
    end
  end

  test 'no followers' do
    user = users(:user_20)
    get followers_user_path(user)
    assert_match user.name, response.body
    assert_select "h3", text: "Followers"
    assert_select 'section.user_avatars', count: 0
    assert_select 'ul.users', count: 0
  end

end
