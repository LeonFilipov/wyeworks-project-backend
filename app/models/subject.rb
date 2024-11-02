class Subject < ApplicationRecord
    belongs_to :career
    has_many :topics
    validates :name, presence: true
end
