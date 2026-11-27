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
end
