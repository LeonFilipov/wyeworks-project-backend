class AvailabilityTutor < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :description, :tentative_date_from, :tentative_date_to, :effective_date, :link, :form, presence: true
end