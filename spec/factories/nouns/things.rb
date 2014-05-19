FactoryGirl.define do
  factory :thing, class: Nouns::Thing do

    name Faker::Lorem.word

  end
end
