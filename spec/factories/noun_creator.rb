FactoryGirl.define do
  factory :noun_creator do

    user
    association :noun, factory: :thing

  end
end
