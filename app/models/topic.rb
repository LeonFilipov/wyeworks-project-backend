class Topic < ApplicationRecord
    belongs_to :subject
    # before_create :validate_show_email

    has_one :availability_tutor, dependent: :destroy
    has_one :tutor, through: :availability_tutor, source: :user
    
    has_many :student_topics, dependent: :destroy
    has_many :student_users, through: :student_topics
    
    validates :name, uniqueness: true
    validates :name, :subject_id, presence: true
    validates :show_email, inclusion: { in: [true, false] }

    scope :for_user, ->(id) { joins(:availability_tutor).where(availability_tutors: { user_id: id }) }
    
    # private
    # def validate_show_email
    #     self.show_email = false unless self.show_email.is_a?(TrueClass) || self.show_email.is_a?(FalseClass)
    # end
end
