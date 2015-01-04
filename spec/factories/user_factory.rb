# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :password do |n|
    "password-#{n}"
  end

  factory :user do
    email
    password

    trait :default do
      email User::DEFAULT_USER_EMAIL
    end
  end
end
