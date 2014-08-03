# Names for common and singleton accounts. All accounts have unique names
# of course, some have models specifically to represent them and their particular
# actions.
module Accounts

  # Assets
  CASH = 'Cash'

  # Revenues
  PURCHASE_REVENUE = "Tip Purchase Revenue"

  # Expenses
  ITUNES_IAP_FEES = "iTunes IAP Fees"

  def self.seed
    CashAccount.create!
    PurchaseRevenueAccount.create!
    Plutus::Expense.create! name: Accounts::ITUNES_IAP_FEES
  end
end
