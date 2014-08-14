# Creates a withdrawal for the user, pulling from their cash account balance.
# Controls the process to guaruntee its security, and creates a withdrawal
# accounting entry in order to adjust the user's cash account balance after
# it has been completed.
#
# The cash payment is sent through Paypal to the user's `paypal_email` attribute.
# If the `paypal_email` does not have a value, the user's primary email is used.
#
# TODO: Better handling of errors. What if we get validation errors on our withdrawal
#       and withdrawal entrys?
#
# TODO: Informative logs or error notifications on failures?
class WithdrawCash

  MINUMUM_BALANCE_REQUIRED = 10 # in dollars
  MAXIMUM_AMOUNT_ALLOWED = 100 # in dollars

  # Public. Execute the withdrawal. If an amount option is not provided, the
  # amount is inferred by withdrawing the user account balance, but limited to
  # the MAXUMUM_AMOUNT_ALLOWED if the balance exceeds this amount.
  #
  # Options:
  #   amount - Float. The amount of cash to withdraw in dollars and cents.
  #   ignore_withdrawal_minimum - Boolean. Whether to ignore the minimum cash
  #      account balance required to make a withdrawal.
  #   ignore_withdrawal_maximum - Boolean. Whether to ignore the maximum cash
  #      amount that can be withdrawn.
  #
  # Raises:
  #   ArgumentError - if the specified amount is more than the user account balance.
  #   ArgumentError - if the specified amount is more than the user has in their
  #                   cash account balance.
  #   ArgumentError - if the specified amount is more than the maximum amount allowed.
  #   Errors::PaypalPayment - if the payment attempt raises an error on the Paypal api
  #
  def call(user, options={})
    options.symbolize_keys!
    amount = options.delete(:amount) || [user.customer_account.balance, MAXUMUM_AMOUNT_ALLOWED].min

    if amount > MAXIMUM_AMOUNT_ALLOWED
      raise ArgumentError, "The amount may not be more than the maxiumum withdrawal amount allowed of #{MAXIMUM_AMOUNT_ALLOWED}"
    end

    if amount < MINUMUM_BALANCE_REQUIRED
      raise ArgumentError, "The amount must be more than minumum withdrawal amount allowed of #{MINUMUM_BALANCE_REQUIRED}"
    end

    if amount > user.customer_account.balance
      raise ArgumentError, "The amount may not be more than the user account balance."
    end

    Withdrawal.transaction do
      payment = make_payment!(user, amount)

      # Create a withdrawal instance.
      withdrawal = Withdrawal.create! user: user,
        amount: amount,
        transaction_id: payment.paymentInfoList.senderTransactionId,
        paypal_response: payment.to_hash

      # Create a withdrawal accounting entry.
      entry = WithdrawalEntryCreator.new.(withdrawal)
    end
  end

  private def make_payment!(user, amount)
    receiver_email = user.paypal_email
    receiver_email = user.email if receiver_email.blank?

    api = PayPal::SDK::AdaptivePayments::API.new
    request = api.build_pay actionType: "PAY",
      # cancelUrl is URL to redirect the sender's browser to after canceling the approval
      # for a payment; it is always required but only used for payments that require approval
      # (explicit payments) which is the case with this request.
      cancelUrl:    "https://tipfortip.com/paypal/pay",
      # URL to redirect the sender's browser to after the sender has logged into PayPal and
      # approved a payment; it is always required but only used if a payment requires explicit
      # approval which is the case with this request
      returnUrl: "https://tipfortip.com/paypal/pay",
      currencyCode: "USD",
      feesPayer:    "SENDER",
      # ipnNotificationUrl: "https://paypal-sdk-samples.herokuapp.com/adaptive_payments/ipn_notify",
      receiverList: {
        receiver: [{
          amount: amount,
          email: receiver_email
        }] },
      sender: { useCredentials: true }

    response = api.pay(request)


    puts '------------'
    puts response.class.name
    p response
    puts '------------'


    unless response.success?
      raise Errors::PaypalPayment, response.error
    end
  end
end

# Example successful payment response:
# {
#   :responseEnvelope => {
#     :timestamp => "2014-08-13T23:17:45-07:00",
#     :ack => "Success",
#     :correlationId => "748379e9b4237",
#     :build => "11853342" },
#   :payKey => "AP-008753514N284002P",
#   :paymentExecStatus => "COMPLETED",
#   :paymentInfoList => {
#     :paymentInfo => [{
#       :transactionId => "2LR87203LB428970R",
#       :transactionStatus => "COMPLETED",
#       :receiver => {
#         :amount => 1.0,
#         :email => "user1@tipfortip.com",
#         :primary => false,
#         :accountId => "YJMRZNJYK3PES" },
#       :pendingRefund => false,
#       :senderTransactionId => "82S37431SL232393F",
#       :senderTransactionStatus => "COMPLETED" }] },
#   :sender => {
#     :accountId => "TWLK53YN7GDM6" } }

# Example unsuccessful payment response:
# {
#   :responseEnvelope => {
#     :timestamp => "2014-08-14T00:00:36-07:00",
#     :ack => "Failure",
#     :correlationId => "92def31f2ab73",
#     :build => "11853342" },
#   :error => [{
#     :errorId => 580001,
#     :domain => "PLATFORM",
#     :subdomain => "Application",
#     :severity => "Error",
#     :category => "Application",
#     :message => "Invalid request: More than one field cannot be used to specify a sender" }] }
