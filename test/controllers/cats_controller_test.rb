require "test_helper"

class CatsControllerTest < ActionDispatch::IntegrationTest
  test "ログインしていると、登録されている猫がカードで表示される" do
    sign_in_as(users(:one))
    get cats_url

    assert_response :success
    assert_select "h1", "猫台帳一覧"
    assert_select ".cat-card", Cat.count
    assert_select ".cat-card", text: /#{cats(:one).area.name}/
    assert_select ".cat-card dd", text: "なし"
  end

  test "ログインしていなくても猫台帳一覧を見られ、メニューには「ログイン」が出る" do
    get cats_url

    assert_response :success
    assert_select ".cat-card", Cat.count
    assert_select "a.site-menu__link[href=?]", new_session_path, text: "ログイン"
    assert_select "a[href=?]", new_sighting_path, count: 0
  end

  test "猫が0匹のときはメッセージを表示し、エラーにならない" do
    # 報告に紐づいた猫もあるので、dependent: :nullify が効く destroy_all で消す
    Cat.destroy_all
    sign_in_as(users(:one))
    get cats_url

    assert_response :success
    assert_select ".cat-card", 0
    assert_select "p", "登録された猫はいません"
  end

  test "メニューの猫台帳一覧が一覧画面へのリンクになっている" do
    sign_in_as(users(:one))
    get cats_url

    assert_select "a.site-menu__link[href=?][aria-current=page]", cats_path, text: "猫台帳一覧"
    assert_select ".site-menu__link--disabled", text: /猫台帳一覧/, count: 0
  end
end
