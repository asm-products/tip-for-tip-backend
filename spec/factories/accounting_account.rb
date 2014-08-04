FactoryGirl.define do
  factory :asset_account, class: "Plutus::Asset" do
    name { "Asset #{SecureRandom.hex 4}" }
  end

  factory :liability_account, class: "Plutus::Liability" do
    name { "Liability #{SecureRandom.hex 4}" }
  end

  factory :revenue_account, class: "Plutus::Revenue" do
    name { "Revenue #{SecureRandom.hex 4}" }
  end

  factory :expense_account, class: "Plutus::Expense" do
    name { "Expense #{SecureRandom.hex 4}" }
  end

  factory :cash_account do
  end

  factory :customer_account do
    user
  end
end
