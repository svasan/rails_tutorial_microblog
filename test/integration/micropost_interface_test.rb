require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user_foo = users(:foobar)
  end

  test "micropost interface on the home page" do
    log_in_as(@user_foo)
    get root_url
    assert_match @user_foo.name, response.body
    assert_select "form.new_micropost", count: 1
    assert_match "#{@user_foo.microposts.count} microposts", response.body
    assert_select "input[type=file]"

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" }}
    end

    # Valid submission
    text = "Some Unique Text. Maybe.".reverse
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: text, picture: picture }}
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match text, response.body
    assert @user_foo.reload.microposts.first.picture?

    # Microposts and delete links exist
    microposts = @user_foo.microposts.paginate(page: 1)
    microposts.each do |m|
      assert_match ERB::Util.html_escape(m.content), response.body
      assert_select "a[href=?]", micropost_path(m), text: "delete"
    end

    # Delete works.
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(microposts.last)
    end

    # No deletes in some other user's profile page
    get user_path(users(:joe))
    assert_select "a", text: "delete", count: 0

    # User with no microposts
    log_in_as(users(:user_25))
    get root_path
    assert_match "0 microposts", response.body
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: "This is User 25!" }}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match "1 micropost", response.body
  end

end
