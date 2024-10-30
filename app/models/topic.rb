class Topic < ApplicationRecord
    belongs_to :subject
    has_one :availability_tutors, dependent: :destroy
    has_many :users, through: :availability_tutors
    
    has_many :student_topics, dependent: :destroy
    has_many :users, through: :student_topics

    validates :name, uniqueness: true
    validates :subject_id, :name, presence: true
end
