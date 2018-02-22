require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(:name => "Example User", :email => "user@example.net")
  end
  
  test "basic validation" do
    assert @user.valid?
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
      assert @user.valid?, "#{a.inspect} is not valid"
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
  
end
