FactoryBot.define do
  factory :topic do
    name { Faker::Educator.course_name }
    description { Faker::Religion::Bible.quote }
    subject_id { nil }
    image_url { Faker::Internet.url }
  end
end
