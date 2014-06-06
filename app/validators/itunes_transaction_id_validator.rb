
# Validates that the transaction_id on the instance can be found in the
# list of in_app receipts within the receipt data.
class ItunesTransactionIdValidator < ActiveModel::Validator

  def validate(record)
    receipt = (record.receipt_data || {}).with_indifferent_access
    unless Array(receipt[:in_app]).any?{ |r| r[:transaction_id] == record.transaction_id }
      record.errors[:transaction_id] << "does not exist in the receipt data."
    end
  end

end
