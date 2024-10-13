FactoryBot.define do
  name = Faker::Name.name
  factory :user do
    name { name }
    email { Faker::Internet.email(name: name)}
    uid { "1234567890" }
    description { "I am a profesor" }
    image_url { "https://www.google.com" }
  end
end
