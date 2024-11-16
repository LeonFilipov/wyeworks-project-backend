FactoryBot.define do
  factory :meet do
    date_time { Faker::Time.forward(days: 23, period: :morning) }
    link { Faker::Internet.url }
    status { "pending" } # meet can be pending or confirmed
    association :availability_tutor
    count_interesteds { 0 }
    trait :confirmed do
      status { "confirmed" }
    end
  end
end
