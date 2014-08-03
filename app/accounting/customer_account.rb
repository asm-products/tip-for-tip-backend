class CustomerAccount < Plutus::Liability

  has_one :user

  validates_presence_of :user

  # Force the name of this customer account.
  before_validation do
    self.name = "Customer #{user.id} Account"
  end

end
