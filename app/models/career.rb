class Career < ApplicationRecord
    has_many :subjects, dependent: :destroy
    belongs_to :university

    validates :name, presence: true, uniqueness: true
end
