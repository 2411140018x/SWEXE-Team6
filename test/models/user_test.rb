require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "role の初期値は住民で、3種類以外は保存できない" do
    user = User.new(email_address: "new@example.com", password: "password")
    assert_equal "住民", user.role
    assert user.valid?

    user.role = "管理者"
    assert_not user.valid?
  end

  test "報告できるのは住民・世話人で、市の職員はできない" do
    assert users(:one).can_report?
    assert users(:two).can_report?
    assert_not users(:city).can_report?
    assert users(:city).city_staff?
  end
end
