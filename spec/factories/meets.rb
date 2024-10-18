FactoryBot.define do
  factory :meet do
    date_time { Faker::Time.forward(days: 23, period: :morning) }
    description { Faker::Religion::Bible.quote }
    link { Faker::Internet.url }
    mode { "virtual" } # meet can be virtual or in-person
    status { "pending" } # meet can be pending or confirmed
    association :availability_tutor
    count_interesteds { 0 }
  end
end
