class Topic < ApplicationRecord
    belongs_to :subject
    has_many :student_topics, dependent: :destroy
    has_many :users, through: :student_topics
    has_many :availability_tutors, dependent: :destroy
    has_many :users, through: :availability_tutors

    validates :name, uniqueness: true
    validates :subject_id, :name, presence: true
end
