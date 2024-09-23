class Topic < ApplicationRecord
    belongs_to :subject
    has_many :availability_tutors
    has_many :users, through: :availability_tutors
end