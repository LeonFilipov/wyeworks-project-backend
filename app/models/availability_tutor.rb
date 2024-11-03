class AvailabilityTutor < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :interesteds, dependent: :destroy
  has_many :interested_users, through: :interesteds, source: :user
  has_many :meets, dependent: :destroy
end
