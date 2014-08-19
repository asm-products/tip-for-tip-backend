FactoryGirl.define do
  factory :withdrawal do

    amount 10
    transaction_id { SecureRandom.hex(4) }
    user

  end
end
