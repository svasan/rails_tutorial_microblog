require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:joe).id,
                                     followed_id: users(:lana).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "nil follower should not be valid" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "nil followed should not be valid" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
