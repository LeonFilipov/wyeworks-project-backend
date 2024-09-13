class Subject < ApplicationRecord
    belongs_to :university
    has_many :topics
    validates :name, presence: true
end
