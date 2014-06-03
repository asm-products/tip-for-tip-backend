class Purchase < ActiveRecord::Base
  SERVICES = %w(itunes)

  belongs_to :user
  belongs_to :tip

  validates_presence_of :user
  validates_presence_of :tip
  validates_presence_of :service
  validates_presence_of :receipt_data
  validates_presence_of :transaction_id
  validates_presence_of :transaction_timestamp
  validates_presence_of :transaction_value
  validates_presence_of :transaction_currency
  validates :service, inclusion: { in: SERVICES }

end
