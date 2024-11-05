FactoryBot.define do
  factory :topic do
    name { Faker::Educator.course_name }
    description { Faker::Religion::Bible.quote }
    image_url { Faker::Internet.url }
    link { Faker::Internet.url }
    show_email { false }
    association :subject
  end
end
