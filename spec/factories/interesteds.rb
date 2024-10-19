FactoryBot.define do
  factory :interested do
    association :user
    association :availability_tutor
  end
end
