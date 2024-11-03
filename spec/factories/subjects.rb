FactoryBot.define do
  factory :subject do
    name { Faker::Educator.subject }
    association :career
  end
end
