class Participant < ApplicationRecord
  belongs_to :meet
  belongs_to :user
end
