class PurchaseEntry < Plutus::Entry
  def self.inheritance_column; :type; end

  has_one :purchase

  validates_presence_of :purchase

  def self.build(hash)
    plutus_entry = Plutus::Entry.build(hash)
    entry = new plutus_entry.attributes
    entry.purchase = hash[:purchase]
    entry.description ||= "Purchase of tip #{entry.purchase.tip.id}"
    entry.debit_amounts  = plutus_entry.debit_amounts
    entry.credit_amounts = plutus_entry.credit_amounts
    entry
  end
end
