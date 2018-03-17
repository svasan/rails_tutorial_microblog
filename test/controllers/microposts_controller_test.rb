require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @orange_post = microposts(:orange)
  end

  test "create should redirect when not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "Random Text" } }
    end
    assert_redirected_to login_url
  end

  test "destroy should redirect when not logged in" do
    assert_no_difference "Micropost.count" do
      delete micropost_path(@orange_post)
    end
    assert_redirected_to login_url
  end

  test "destroy should redirect for incorrect user" do
    log_in_as(users(:lana))
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@orange_post)
    end
    assert_redirected_to root_url
  end

end
