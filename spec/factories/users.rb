FactoryBot.define do
  name = Faker::Name.name
  factory :user do
    name { name }
    email { Faker::Internet.email(name: name) }
    uid { Faker::Number.number(digits: 10) }
    description { Faker::Religion::Bible.quote }
    image_url { Faker::Internet.url }
  end
end
