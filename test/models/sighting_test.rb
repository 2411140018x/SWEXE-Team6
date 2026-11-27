require "test_helper"

class SightingTest < ActiveSupport::TestCase
  test "猫が空でも、地区・種類・内容があれば保存できる" do
    sighting = users(:one).sightings.new(area: areas(:one), kind: "目撃", description: "白い猫を見た")
    assert sighting.valid?
    assert_equal "未確認", sighting.status
  end

  test "地区・種類・内容が空だと保存できない" do
    sighting = users(:one).sightings.new
    assert_not sighting.valid?
    assert_includes sighting.errors[:area], "地区を選んでください（猫を選んだ場合は自動で入ります）"
    assert_includes sighting.errors[:kind], "報告の種類を選んでください"
    assert_includes sighting.errors[:description], "報告内容を記入してください"
  end
end
