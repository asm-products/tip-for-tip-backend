class Purchase < ActiveRecord::Base
  SERVICES = %w(itunes google)

  belongs_to :user
  belongs_to :tip
  belongs_to :iap_receipt_verification

  # Accounting association
  belongs_to :purchase_entry, autosave: true

  validates_presence_of :user
  validates_presence_of :tip
  validates_presence_of :service
  validates_inclusion_of :service, in: SERVICES, allow_blank: true
  validates_presence_of :transaction_id
  validates_uniqueness_of :transaction_id, scope: :service, allow_blank: true

  validates_presence_of :iap_receipt_verification
  validates_each :iap_receipt_verification, allow_blank: true do |record, attr, value|
    record.errors.add attr, 'must be valid.' unless value.valid?
    record.errors.add attr, 'must be successful.' unless value.successful?
  end


  SERVICES.each do |service_name|
    define_method "#{service_name}?" do
      self.service.to_s == service_name.to_s
    end
  end

  before_validation do
    self.service = self.service.to_s
  end
end
