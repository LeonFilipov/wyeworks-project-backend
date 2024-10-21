class User < ApplicationRecord
    has_many :student_topics
    has_many :topics, through: :student_topics

    validates :email, presence: true, uniqueness: true
    validates :uid, presence: true, uniqueness: true
    validates :ranking, :amount_given_lessons, :amount_given_topics, :amount_attended_students, numericality: { only_integer: true }, allow_nil: true


    has_many :availability_tutors
    has_many :topics, through: :availability_tutors
    has_many :interesteds
    has_many :interested_availability_tutors, through: :interesteds, source: :availability_tutor

    has_many :participants, dependent: :destroy
    has_many :meets, through: :participants

    def self.google_auth(user_info)
        where(email: user_info["email"]).first_or_initialize do |user|
            user.name = user_info["name"]
            user.email = user_info["email"]
            user.uid = user_info["sub"]
            user.description = ""
            user.image_url = user_info["picture"]
        end
    end
end
