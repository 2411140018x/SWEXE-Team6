class Area < ApplicationRecord
  has_many :cats
  validates :name, presence: true
end
