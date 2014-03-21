FactoryGirl.define do
  factory :word do
    sequence(:text) { |n| "word#{n}" }
  end
end
