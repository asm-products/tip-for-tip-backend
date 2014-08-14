# Singleton
class CashAccount < Plutus::Asset
  NAME = Accounts::CASH

  # There can only be one of these accounts. We enforce this by forcing
  # the account name and relying on uniqueness validation.
  before_validation { self.name = NAME }

end
