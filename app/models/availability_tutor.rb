class AvailabilityTutor < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :interesteds
  has_many :interested_users, through: :interesteds, source: :user
  has_many :meets, dependent: :destroy


  validates :description, :link, presence: true
end
