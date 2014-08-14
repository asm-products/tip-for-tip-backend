class WithdrawalEntry < Plutus::Entry
  def self.inheritance_column; :type; end

  has_one :withdrawal

  validates_presence_of :withdrawal
end
