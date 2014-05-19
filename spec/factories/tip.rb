FactoryGirl.define do

  factory :tip do

    subject Faker::Lorem.sentence
    body Faker::Lorem.paragraph
    user
    association :noun, factory: :place

  end

end
