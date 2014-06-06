class Purchase < ActiveRecord::Base
  SERVICES = %w(itunes)

  belongs_to :user
  belongs_to :tip

  validates_presence_of :user
  validates_presence_of :tip
  validates_presence_of :service
  validates_presence_of :receipt_data, if: :verified
  validates_presence_of :encoded_receipt_data
  validates_presence_of :transaction_id
  validates :service, inclusion: { in: SERVICES }

  # Validating uniqueness of transaction id protects us from a hacker
  # using the same valid receipt to purchase multiple tips.
  validates_uniqueness_of :transaction_id, scope: :verified, if: :verified

  SERVICES.each do |service_name|
    define_method "#{service_name}?" do
      self.service.to_s == service_name.to_s
    end
  end

  after_initialize do
    self.verified = false if self.verified.nil?
  end

  before_validation do
    self.service = self.service.to_s
  end

end

