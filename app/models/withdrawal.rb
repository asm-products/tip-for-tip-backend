class Withdrawal < ActiveRecord::Base

  belongs_to :user
  belongs_to :withdrawal_entry

  validates_presence_of :user
  validates_presence_of :transaction_id

end
