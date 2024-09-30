class Meet < ApplicationRecord
  belongs_to :availability_tutor
  validates :description, presence: true
  validates :link, presence: true
  validates :mode, inclusion: { in: ['virtual', 'in-person'] }
  validates :status, inclusion: { in: ['pending', 'confirmed'] }

  # Custom validation: Only validate date_time if status is confirmed
  validate :date_time_required_for_confirmed_meeting

  private

  # Custom validation method
  def date_time_required_for_confirmed_meeting
    if status == 'confirmed' && date_time.nil?
      errors.add(:date_time, "must be set when the meeting is confirmed")
    end
  end
end
