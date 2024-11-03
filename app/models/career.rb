class Career < ApplicationRecord
    belongs_to :university
    has_many :subjects, dependent: :destroy
    has_many :users

    validates :name, presence: true, uniqueness: true
end
