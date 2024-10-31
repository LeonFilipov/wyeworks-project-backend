FactoryBot.define do
  factory :availability_tutor do
    association :user
    association :topic
  end
end
