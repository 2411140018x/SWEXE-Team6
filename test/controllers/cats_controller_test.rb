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

  test "ログインしていないとログイン画面に移動する" do
    get cats_url

    assert_redirected_to new_session_path
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

  test "一覧の各カードが、その猫の詳細画面へのリンクになっている" do
    sign_in_as(users(:one))
    get cats_url

    assert_select "a.cat-card__link", Cat.count
    Cat.find_each do |cat|
      assert_select "a.cat-card__link[href=?]", cat_path(cat)
    end
  end

  # ===== 各猫詳細画面 =====

  test "詳細画面に、呼び名・性別・耳先カット・地区・特徴が表示される" do
    cat = cats(:one)
    cat.update!(name: "みけ", sex: "メス", ear_cut: true, features: "三毛・しっぽが短い")
    sign_in_as(users(:one))
    get cat_url(cat)

    assert_response :success
    assert_select "h1", "みけ"
    assert_select ".cat-detail__info dd", text: "メス"
    assert_select ".cat-detail__info dd", text: "あり"
    assert_select ".cat-detail__info dd", text: cat.area.name
    assert_select ".cat-detail__info dd", text: "三毛・しっぽが短い"
    assert_select "a[href=?]", cats_path, text: /猫台帳一覧に戻る/
  end

  test "その猫への報告が、新しい順に日本時間の日時・対応状況・種類・内容つきで表示される" do
    cat = cats(:one)
    cat.sightings.destroy_all
    cat.sightings.create!(user: users(:one), area: cat.area, kind: "目撃", description: "古い報告",
                          status: "対応済", created_at: Time.utc(2026, 11, 1, 3, 0))
    cat.sightings.create!(user: users(:two), area: cat.area, kind: "鳴き声", description: "新しい報告",
                          status: "未確認", created_at: Time.utc(2026, 11, 27, 15, 30))
    sign_in_as(users(:one))
    get cat_url(cat)

    assert_response :success
    descriptions = css_select(".cat-report__description").map { |e| e.text.strip }
    assert_equal [ "新しい報告", "古い報告" ], descriptions

    # UTC 2026/11/27 15:30 は日本時間で 11/28 00:30
    assert_select ".cat-report__time", text: "2026/11/28 00:30"
    assert_select ".status-badge.status-badge--unconfirmed", text: "未確認"
    assert_select ".status-badge.status-badge--done", text: "対応済"
    assert_select ".cat-report__kind", text: "鳴き声"
  end

  test "ほかの猫への報告は表示されない" do
    other_cat = cats(:two)
    other_cat.sightings.create!(user: users(:one), area: other_cat.area, kind: "目撃", description: "別の猫の報告")
    sign_in_as(users(:one))
    get cat_url(cats(:one))

    assert_select ".cat-report__description", text: "別の猫の報告", count: 0
  end

  test "報告が1件も無い猫は「この猫への報告はまだありません」と表示される" do
    cat = cats(:one)
    cat.sightings.destroy_all
    sign_in_as(users(:one))
    get cat_url(cat)

    assert_response :success
    assert_select ".cat-report", 0
    assert_select "p", "この猫への報告はまだありません"
  end

  test "特徴が空の猫は、特徴に「未登録」と表示される" do
    cat = cats(:one)
    cat.update!(features: "")
    sign_in_as(users(:one))
    get cat_url(cat)

    assert_response :success
    assert_select ".cat-detail__info dd", text: "未登録"
  end

  test "詳細画面は、ログインしていないとログイン画面に移動する" do
    get cat_url(cats(:one))

    assert_redirected_to new_session_path
  end

  test "存在しない猫のIDを開くと404になり、500エラーにならない" do
    sign_in_as(users(:one))
    get cat_url(id: Cat.maximum(:id).to_i + 1)

    assert_response :not_found
  end
end
