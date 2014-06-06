# Handles the creation of a purchase. Also verifies the receipt data with iTunes
# and verifies that the decoded receipt data contains the transaction id.
# A receipt that is not verified will still be saved to the database, but will have
# verified=false.
class ItunesPurchaseCreator

  def call(user, tip, transaction_id, encoded_receipt_data)

    purchase = Purchase.new service: :itunes,
                            tip: tip,
                            user: user,
                            transaction_id: transaction_id,
                            encoded_receipt_data: encoded_receipt_data,
                            verified: false

    begin
      # Verify with apple
      purchase.receipt_data = Venice::Receipt.verify!(encoded_receipt_data).to_hash

      # Make sure the transaction id is in the decoded receipt data
      unless purchase.receipt_data[:in_app].any?{ |r| r[:transaction_id] == transaction_id }
        error = Errors::ReceiptVerification.new "The transaction id (#{transaction_id}) is not in the list of transactions in the receipt data.",
          transaction_id, purchase.receipt_data
        raise error
      end

      purchase.verified = true
    rescue Venice::Receipt::VerificationError => e
      purchase.receipt_data = e.receipt.to_hash rescue nil
      purchase.unverified_reason = e.message
      Rails.logger.warn "iTunes receipt verification failed. message=\"#{e.message}\" transaction_id=#{transaction_id} user_id=#{user.id} tip_id=#{tip.id}"
    rescue Errors::ReceiptVerification => e
      purchase.receipt_data = e.receipt.to_hash rescue nil
      purchase.unverified_reason = e.message
      Rails.logger.warn "Receipt verification failed. message=\"#{e.message}\" transaction_id=#{transaction_id} user_id=#{user.id} tip_id=#{tip.id}"
    ensure
      purchase.save!
    end

    purchase
  end

end
