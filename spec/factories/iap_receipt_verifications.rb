FactoryGirl.define do
  factory(:iap_receipt_verification) do

    user
    encoded_receipt_data "encoded receipt data"
    receipt_data "decoded receipt data"
    sequence :transaction_id
    service "itunes"

    trait :successful do
      successful true
      result '0'
      result_message nil
    end

    trait :unsuccessful do
      successful false
      result '21003'
      result_message 'The receipt could not be authenticated.'
    end

    successful
  end
end
