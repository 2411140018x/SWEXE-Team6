class Area < ApplicationRecord
  has_many :cats, dependent: :restrict_with_error
  validates :name, presence: true
end
