class User < ApplicationRecord
  ROLES = %w[世話人 住民 市の職員].freeze
  # 猫の報告ができるのは地域に住んでいる人（住民・世話人）
  REPORTER_ROLES = %w[世話人 住民].freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :sightings

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :role, inclusion: { in: ROLES }

  def city_staff?
    role == "市の職員"
  end

  def can_report?
    REPORTER_ROLES.include?(role)
  end
end
