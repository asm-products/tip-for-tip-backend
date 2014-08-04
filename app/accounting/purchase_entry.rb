class PurchaseEntry < Plutus::Entry
  def self.inheritance_column; :type; end

  has_one :purchase

  validates_presence_of :purchase
end
