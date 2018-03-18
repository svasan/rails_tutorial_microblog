require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(:name => "Example User", :email => "user@example.net",
                     :password => "foobar12", :password_confirmation => "foobar12")
  end

  test "basic validation" do
    assert @user.valid?, "Failed with #{@user.errors.full_messages}"
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "name too long" do
    @user.name = "a" * 256
    assert_not @user.valid?
  end

  test "email too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "accept valid email addresses" do
    addresses = %w[user@example.com USER@FOO.COM U-S-E-R@foo.com U_SE-R@foo.com.jp first.last@xyz.jj first+last@xyz.jj.yy]
    addresses.each do |a|
      @user.email = a
      assert @user.valid?, "#{a.inspect} is not valid. #{@user.errors.full_messages}"
    end
  end

  test "should not accept invalid email addresses" do
    addresses = %w[user@example,com user_at_foo.com user@example user@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com .foo@bar.com foo.@bar.com foo..bar@baz.com]
    addresses.each do |a|
      @user.email = a
      assert_not @user.valid?, "#{a.inspect} is valid"
    end
  end

  test "unique email" do
    dup = @user.dup
    @user.save
    dup.email.upcase!
    assert_not dup.valid?, "Duplicate but upper-case email #{dup.email} is valid"
  end

  test "email saved as lowercase" do
    mixed_case = "SOME.other@Example.com"
    @user.email = mixed_case
    @user.save
    assert_equal mixed_case.downcase, @user.reload.email, "#{@user.email} was not downcased on save"
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 10
    assert_not @user.valid?, "Blank password accepted!"
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?, "Password less than min length accepted!"
  end

  test "authenticated? should handle nil digest" do
    @user.authenticated?(:remember, '')
  end

  test "related microposts are destroyed with the user" do
    @user.save
    @user.microposts.create!(content: "Random text")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'user follow and unfollow' do
    joe = users(:joe)
    lana = users(:lana)
    assert_not joe.following?(lana)
    joe.follow(lana)
    assert joe.following?(lana)
    joe.unfollow(lana)
    assert_not joe.following?(lana)
  end
end
