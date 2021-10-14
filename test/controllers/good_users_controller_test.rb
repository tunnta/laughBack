require "test_helper"

class GoodUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get good_users_create_url
    assert_response :success
  end

  test "should get destroy" do
    get good_users_destroy_url
    assert_response :success
  end
end
