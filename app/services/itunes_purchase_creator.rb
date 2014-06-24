# Handles the creation of a purchase. Also verifies the receipt data with iTunes
# and verifies that the decoded receipt data contains the transaction id.
class ItunesPurchaseCreator

  def call(user, tip, transaction_id, encoded_receipt_data, options={})
    options.symbolize_keys!

    verification = IapReceiptVerification.new service: :itunes,
                                              user: user,
                                              transaction_id: transaction_id,
                                              encoded_receipt_data: encoded_receipt_data,
                                              request_metadata: options[:request_metadata]

    begin
      # Verify with apple
      verification.receipt_data = Venice::Receipt.verify!(encoded_receipt_data).to_hash

      # Make sure the transaction id is in the decoded receipt data
      unless verification.receipt_data[:in_app].any?{ |r| r[:transaction_id] == transaction_id }
        error = Errors::ReceiptVerification.new "The transaction id (#{transaction_id}) is not in the list of transactions in the receipt data.",
          transaction_id, verification.receipt_data
        raise error
      end

      verification.successful = true
    rescue Venice::Receipt::VerificationError => e
      verification.receipt_data = e.receipt.to_hash rescue nil
      verification.result = e.code
      verification.result_message = e.message
      Rails.logger.warn "iTunes receipt verification failed. message=\"#{e.message}\" transaction_id=#{transaction_id} user_id=#{user.id} tip_id=#{tip.id}"
    rescue Errors::ReceiptVerification => e
      verification.receipt_data = e.receipt.to_hash rescue nil
      verification.result = 0
      verification.result_message = e.message
      Rails.logger.warn "iTunes Receipt verification failed. message=\"#{e.message}\" transaction_id=#{transaction_id} user_id=#{user.id} tip_id=#{tip.id}"
    rescue Exception => e
      verification.result = "-1"
      verification.result_message = "#{e.message}\n#{e.stacktrace}"
      Rails.logger.error "Encountered unexpected error during iTunes receipt verificaiton: message=\"#{e.message}\" transaction_id=#{transaction_id} user_id=#{user.id} tip_id=#{tip.id}"
    ensure
      verification.save!
    end

    if verification.successful
      purchase = Purchase.create! service: :itunes,
                                  tip: tip,
                                  user: user,
                                  transaction_id: transaction_id,
                                  iap_receipt_verification: verification

      purchase
    else
      false
    end

  end

end
