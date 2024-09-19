class Topic < ApplicationRecord
    belongs_to :subject
    has_many :student_topics
    has_many :users, through: :student_topics
end
