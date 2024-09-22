class Tutor < ApplicationRecord
  belongs_to :user
  has_many :availability_tutors
  has_many :topics, through: :given_topics # si la asociación con Topics es a través de otra tabla
end
