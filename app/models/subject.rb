class Subject < ApplicationRecord
    belongs_to :university
    has_many :topics
end
