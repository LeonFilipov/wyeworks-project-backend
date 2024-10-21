FactoryBot.define do
  factory :availability_tutor do
    association :user
    association :topic
    description { Faker::Religion::Bible.quote }
    link { Faker::Internet.url }
    availability { "Lunes a viernes" }
  end
end
