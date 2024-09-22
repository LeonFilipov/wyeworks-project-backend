class Topic < ApplicationRecord
    belongs_to :subject
    has_many :given_topics
    has_many :tutors, through: :given_topics
end
