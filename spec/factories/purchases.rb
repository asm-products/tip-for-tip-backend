FactoryGirl.define do
  factory :purchase do

    trait :itunes do
      service "itunes"
    end
    trait :google do
      service "google"
    end

    itunes
    receipt_data "encrypted receipt data"
    sequence :transaction_id
    transaction_timestamp 1.minute.ago
    transaction_value 99
    transaction_currency 'USD'

    user
    tip
  end

  factory :google do
    google
  end
end
