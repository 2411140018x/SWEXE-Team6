require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "ログインしているとトップ画面を表示できる" do
    sign_in_as(User.take)
    get root_url
    assert_response :success
  end

  test "ログインしていないとログイン画面に移動する" do
    get root_url
    assert_redirected_to new_session_path
  end
end