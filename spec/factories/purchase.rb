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

    user
    tip
    iap_receipt_verification

  end
end
