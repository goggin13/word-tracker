FactoryBot.define do
  factory :note do
    sequence(:front) { |n| "front-#{n}" }
    sequence(:back) { |n| "back-#{n}" }
    association :user
  end
end
