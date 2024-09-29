class Tentative < ApplicationRecord
  belongs_to :availability_tutor

  validates :day, :schedule_from, :schedule_to, presence: true
  validate :max_tentatives_per_availability_tutor

  def max_tentatives_per_availability_tutor
    if availability_tutor.tentatives.count >= 7
      errors.add(:availability_tutor, "can only have up to 7 tentative schedules.")
    end
  end
end
