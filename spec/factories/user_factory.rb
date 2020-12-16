# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :user do
    sequence(:email, 1000) { |n| "person#{n}@example.com" }
    sequence(:password, 1000) { |n| "password-#{n}" }

    trait :default do
      email { User::DEFAULT_USER_EMAIL }
    end
  end
end
