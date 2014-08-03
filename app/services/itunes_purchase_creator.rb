# Handles the creation of a purchase. Also verifies the receipt data with iTunes
# and verifies that the decoded receipt data contains the transaction id.
class ItunesPurchaseCreator

  def call(user, tip, transaction_id, encoded_receipt_data, options={})
    options.symbolize_keys!
    transaction_id = transaction_id.to_s

    verification = IapReceiptVerification.new service: :itunes,
                                              user: user,
                                              successful: false,
                                              transaction_id: transaction_id,
                                              encoded_receipt_data: encoded_receipt_data,
                                              request_metadata: options[:request_metadata]

    begin
      # Verify with apple
      verification.receipt_data = Venice::Receipt.verify!(encoded_receipt_data).to_hash

      # Make sure the transaction id is in the decoded receipt data
      unless verification.receipt_data[:in_app].any?{ |r| r.symbolize_keys[:transaction_id].to_s == transaction_id }
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

      purchase = Purchase.new service: :itunes,
        tip: tip,
        user: user,
        transaction_id: transaction_id,
        iap_receipt_verification: verification

      # Record the accounting entries for this purchase.
      entry = PurchaseEntry.build purchase: purchase,
        debits: [
          { account: Accounts::CASH,            amount: 0.69 }, # Cash we control
          { account: Accounts::ITUNES_IAP_FEES, amount: 0.30 }  # The fee is already paid
        ],
        credits: [
          { account: tip.user.customer_account.name, amount: 0.50 }, # We owe the creator this much
          { account: Accounts::PURCHASE_REVENUE,     amount: 0.49 }  # The rest is our gross revenue
        ]

      Purchase.transaction do
        entry.save!
        purchase.purchase_entry = entry
        purchase.save!
      end
      purchase
    else
      false
    end

  end

end
