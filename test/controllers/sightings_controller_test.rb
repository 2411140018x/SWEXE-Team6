require "test_helper"

class SightingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "ログインしていないとフォームを開けずログイン画面に移動する" do
    get new_sighting_url
    assert_redirected_to new_session_path
  end

  test "ログインしているとフォームを表示できる" do
    sign_in_as(@user)
    get new_sighting_url
    assert_response :success
  end

  test "報告を送ると未確認で保存され、申請完了画面に移動する" do
    sign_in_as(@user)
    assert_difference("Sighting.count", 1) do
      post sightings_url, params: { sighting: { cat_id: "", area_id: areas(:one).id, kind: "鳴き声", description: "夜に鳴いている" } }
    end
    sighting = Sighting.last
    assert_equal @user, sighting.user
    assert_nil sighting.cat
    assert_equal "未確認", sighting.status
    assert_redirected_to complete_sightings_url
  end

  test "猫を選ぶと地区はその猫の地区になる" do
    sign_in_as(@user)
    post sightings_url, params: { sighting: { cat_id: cats(:two).id, area_id: areas(:one).id, kind: "目撃", description: "見かけた" } }
    assert_equal cats(:two).area, Sighting.last.area
  end

  test "空欄があると保存せずにフォームをエラー付きで表示する" do
    sign_in_as(@user)
    assert_no_difference("Sighting.count") do
      post sightings_url, params: { sighting: { cat_id: "", area_id: "", kind: "", description: "" } }
    end
    assert_response :unprocessable_entity
    assert_match "報告内容を記入してください", response.body
  end

  test "申請完了画面を表示できる" do
    sign_in_as(@user)
    get complete_sightings_url
    assert_response :success
  end

  test "一覧：ログインしていないとログイン画面に移動する" do
    get sightings_url
    assert_redirected_to new_session_path
  end

  test "一覧：自分の報告だけが表示され、他のユーザーの報告は表示されない" do
    sign_in_as(@user)
    get sightings_url
    assert_response :success
    assert_match sightings(:one).description, response.body
    assert_no_match sightings(:two).description, response.body
  end

  test "一覧：新しい報告が上に表示される" do
    sign_in_as(@user)
    @user.sightings.create!(area: areas(:one), kind: "目撃", description: "古い報告", created_at: 2.days.ago)
    @user.sightings.create!(area: areas(:one), kind: "目撃", description: "新しい報告", created_at: 1.hour.ago)
    get sightings_url
    assert_operator response.body.index("新しい報告"), :<, response.body.index("古い報告")
  end

  test "一覧：猫が紐づいていない報告は「未設定」と表示され、対応状況も表示される" do
    sign_in_as(users(:two))
    get sightings_url
    assert_response :success
    assert_match "未設定", response.body
    assert_match "未確認", response.body
  end

  test "一覧：報告が0件のときは「まだ報告はありません」と表示される" do
    sign_in_as(@user)
    Sighting.where(user: @user).delete_all
    get sightings_url
    assert_response :success
    assert_match "まだ報告はありません", response.body
  end

  test "一覧：メニューの自分の報告一覧がリンクになり、開いているときは aria-current が付く" do
    sign_in_as(@user)
    get sightings_url
    assert_select "a.site-menu__link[href=?][aria-current=page]", sightings_path, text: "自分の報告一覧"
  end
end
