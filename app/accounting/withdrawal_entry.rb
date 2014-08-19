class WithdrawalEntry < Plutus::Entry
  has_one :withdrawal

  validates_presence_of :withdrawal
end
