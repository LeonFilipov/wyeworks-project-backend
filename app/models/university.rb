class University < ApplicationRecord
    has_many :careers
    validates :name, presence: true
    validates :location, presence: true
end
