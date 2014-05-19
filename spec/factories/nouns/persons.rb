FactoryGirl.define do
  factory :person, class: Nouns::Person do

    name Faker::Name.name

  end
end
