FactoryBot.define do
  factory :word do
    sequence(:text) { |n| "word#{n}" }
    association :user
  end
end
