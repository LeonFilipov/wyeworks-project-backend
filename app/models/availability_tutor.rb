class AvailabilityTutor < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :tentatives, dependent: :destroy

  validates :description, :date_from, :date_to, :link, presence: true
end
