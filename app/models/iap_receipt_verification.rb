class IapReceiptVerification < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :user
  validates_presence_of :receipt_data, if: :successful
  validates_presence_of :encoded_receipt_data
  validates_presence_of :service
  validates_inclusion_of :service, in: Purchase::SERVICES , allow_blank: true
  validates_presence_of :result,         unless: :successful
  validates_presence_of :result_message, unless: :successful

  before_validation do
    self.service = self.service.to_s
  end

  # Public: Finds the transaction data in the
  def transaction_data
    if self.receipt_data.is_a? Hash
      Array(self.receipt_data['in_app']).find do |t|
        t["transaction_id"].to_s == transaction_id.to_s
      end
    end
  end

end
