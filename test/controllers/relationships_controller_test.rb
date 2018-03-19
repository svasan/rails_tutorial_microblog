require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  test "post redirects when not logged in" do
    assert_no_difference "Relationship.count" do
      post relationships_path, params: { followed_id: users(:foobar).id }
    end
    assert_redirected_to login_url
  end

  test "delete redirects when not logged in" do
    assert_no_difference "Relationship.count" do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
