module CatsHelper
  # 報告の対応状況ごとのバッジの色（CSSのクラス名）
  SIGHTING_STATUS_BADGE_CLASSES = {
    "未確認" => "status-badge--unconfirmed",
    "確認済" => "status-badge--confirmed",
    "対応済" => "status-badge--done"
  }.freeze

  def sighting_status_badge_class(status)
    SIGHTING_STATUS_BADGE_CLASSES.fetch(status, "status-badge--unconfirmed")
  end
end
