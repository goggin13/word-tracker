# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :definition do |d|
    sequence(:text) { |n| "this is the defintion of a word - #{n}" }
    sequence(:example) { |n| "this is an example use of a word - #{n}" }
    word_id { FactoryGirl.create(:word).id }
  end
end
