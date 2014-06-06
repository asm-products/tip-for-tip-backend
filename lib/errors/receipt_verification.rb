module Errors
  class ReceiptVerification < StandardError

    attr_accessor :transaction_id
    attr_accessor :receipt_data

    def initialize(message, transaction_id, receipt_data)
      @message = message
      @transaction_id = transaction_id
      @receipt_data = receipt_data
    end
  end
end
