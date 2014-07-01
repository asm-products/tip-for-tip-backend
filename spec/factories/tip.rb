FactoryGirl.define do

  factory :tip do
    subject Faker::Lorem.sentence
    body Faker::Lorem.paragraph
    user
    association :noun, factory: :place

    trait :free do
      is_free true
    end

    trait :compliment do
      is_compliment true
    end

    trait :anonymous do
      display_as :anonymous
    end
  end

end
