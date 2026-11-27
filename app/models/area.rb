class Area < ApplicationRecord
  has_many :cats, dependent: :restrict_with_error
  has_many :sightings
  validates :name, presence: true
end
