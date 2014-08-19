class PurchaseEntry < Plutus::Entry
  has_one :purchase

  validates_presence_of :purchase
end
