require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user_foo = users(:foobar)
    @micropost =@user_foo.microposts.build(content: "Random Text")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "microposts should always have a user_id" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should not be empty" do
    @micropost.content = "    "
    assert_not @micropost.valid?
  end

  test "content should not be more than 140 chars" do
    @micropost.content = "A" * 141
    assert_not @micropost.valid?
  end

  test "most recent should be first" do
    assert microposts(:most_recent) == Micropost.first
  end
end
