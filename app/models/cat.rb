class Cat < ApplicationRecord
  SEXES = %w[オス メス 不明].freeze

  belongs_to :area
  has_many :sightings, dependent: :nullify
  validates :name, presence: true
  validates :sex, inclusion: { in: SEXES }
end
