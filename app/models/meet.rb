class Meet < ApplicationRecord
  belongs_to :availability_tutor
  validates :link, presence: true
  validates :status, inclusion: { in: [ "pending", "confirmed", "cancelled", "completed" ] }

  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  # Custom validation: Only validate date_time if status is confirmed
  validate :date_time_required_for_confirmed_meeting
  private
  # Custom validation method
  def date_time_required_for_confirmed_meeting
    if status == "confirmed" && date_time.nil?
      errors.add(:date_time, "must be set when the meeting is confirmed")
    end
  end

  scope :past_meets, -> { where("date_time < ?", Time.current) }

  def self.mark_finished_meets
    past_meets.update_all(status: "completed")
  end
end
