FactoryBot.define do
  factory :subject do
    name { Faker::Educator.subject }
    association :university
  end
end
