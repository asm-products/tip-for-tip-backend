FactoryGirl.define do
  factory :purchase do

    trait :itunes do
      service "itunes"
    end
    trait :google do
      service "google"
    end

    trait :verified do
      verified true
    end

    itunes
    sequence :transaction_id
    transaction_timestamp 1.minute.ago
    encoded_receipt_data "encoded receipt data"
    receipt_data { ::Support::ItunesReceipts.parsed }
    verified false

    user
    tip
  end

  factory :google do
    google
  end
end
