class Sighting < ApplicationRecord
  KINDS = %w[目撃 ふん尿 庭荒らし 鳴き声 その他].freeze
  STATUSES = %w[未確認 確認済 対応済].freeze

  belongs_to :user
  # 地区は下の validates で日本語メッセージ付きで必須チェックする
  belongs_to :area, optional: true
  # 住民はどの猫か分からないことが多いので空でもよい（後で世話人が紐づける）
  belongs_to :cat, optional: true

  validates :area, presence: { message: "地区を選んでください（猫を選んだ場合は自動で入ります）" }
  validates :kind, inclusion: { in: KINDS, message: "報告の種類を選んでください" }
  validates :description, presence: { message: "報告内容を記入してください" }
  validates :status, inclusion: { in: STATUSES }
end
