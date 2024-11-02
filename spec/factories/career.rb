FactoryBot.define do
  factory :career do
    name { Faker::Educator.course_name }
    association :university
  end
end
