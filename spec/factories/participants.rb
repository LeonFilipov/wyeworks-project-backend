FactoryBot.define do
  factory :participant do
    association :user
    association :meet
  end
end
