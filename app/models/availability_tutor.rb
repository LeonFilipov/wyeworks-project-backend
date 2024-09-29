class AvailabilityTutor < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :description, :date_from, :date_to, :link, presence: true
end
