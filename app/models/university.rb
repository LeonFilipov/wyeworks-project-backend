class University < ApplicationRecord
    has_many :subjects
    validates :name, presence: true
    validates :location, presence: true
end
