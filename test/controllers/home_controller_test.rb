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

  test "住民でログインすると、トップとメニューに報告の機能が出る" do
    sign_in_as(users(:one))
    get root_url
    assert_select "h1", "トップ"
    assert_select "main a[href=?]", new_sighting_path
    assert_select "a.site-menu__link[href=?]", new_sighting_path
    assert_select "a.site-menu__link[href=?]", sightings_path
  end

  test "市の職員でログインすると、市の職員用トップになり報告の機能は出ない" do
    sign_in_as(users(:city))
    get root_url
    assert_select "h1", "市の職員用トップ"
    assert_select "a[href=?]", new_sighting_path, count: 0
    assert_select ".site-menu__link--disabled", text: /地区ごとの集計/
  end
end
