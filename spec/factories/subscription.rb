FactoryGirl.define do
  factory :subscription do

    partner
    association :noun, factory: :place

  end
end
