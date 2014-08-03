# Singleton
class PurchaseRevenueAccount < Plutus::Liability
  NAME = Accounts::PURCHASE_REVENUE

  # There can only be one of these accounts. We enforce this by forcing
  # the account name and relying on uniqueness validation.
  before_validation { self.name = NAME }

end
