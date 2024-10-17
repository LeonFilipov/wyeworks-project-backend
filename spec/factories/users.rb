FactoryBot.define do
  name = Faker::Name.name
  factory :user do
    name { name }
    email { Faker::Internet.email(name: name)}
    uid { Faker::Number.number(digits: 10) }
    description { "I am a profesor" }
    image_url { "https://www.google.com" }
  end
end
