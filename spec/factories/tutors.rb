FactoryBot.define do
  factory :tutor do
    user { nil }
    ranking { 1 }
    amount_given_lessons { 1 }
    amount_given_topics { 1 }
    amount_attended_students { 1 }
  end
end
