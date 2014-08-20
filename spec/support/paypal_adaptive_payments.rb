module Support
  module Paypal
    module AdaptivePayments
      module Pay

        module Stub
          def stub_paypal_pay!
            allow_any_instance_of(::PayPal::SDK::AdaptivePayments::API).to receive(:pay).
              and_return Pay.successful_response
          end

          def stub_paypal_pay_failure!
            allow_any_instance_of(::PayPal::SDK::AdaptivePayments::API).to receive(:pay).
              and_return Pay.unsuccessful_response
          end
        end

        def self.successful_response(email=nil, amount=nil)
          email ||= 'foo@bar.com'
          amount = 10 if amount.nil?

          ::PayPal::SDK::AdaptivePayments::DataTypes::PayResponse.new responseEnvelope: {
              timestamp: 10.seconds.ago,
              ack: "Success",
              correlationId: SecureRandom.hex(3),
            },
            payKey: SecureRandom.hex(3),
            success?: true,
            paymentExecStatus: "COMPLETED",
            paymentInfoList: {
              paymentInfo: [
                {
                  pendingRefund: false,
                  receiver: {
                    accountId: SecureRandom.hex(3),
                    amount: amount,
                    email: email,
                    primary: false
                  },
                  senderTransactionId: SecureRandom.hex(3),
                  senderTransactionStatus: "COMPLETED",
                  transactionId: SecureRandom.hex(3),
                  transactionStatus: "COMPLETED"
                }
              ]
            },
            sender: {
              accountId: SecureRandom.hex(3)
            }
        end

        def self.unsuccessful_response()
          ::PayPal::SDK::AdaptivePayments::DataTypes::PayResponse.new responseEnvelope: {
              timestamp: 10.seconds.ago,
              ack: "Failure",
              correlationId: SecureRandom.hex(3),
            },
            error: [{
              errorId:   580001,
              domain:    "PLATFORM",
              subdomain: "Application",
              severity:  "Error",
              category:  "Application",
              message:   "Invalid request: More than one field cannot be used to specify a sender"
            }]
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Support::Paypal::AdaptivePayments::Pay::Stub, type: :controller
  config.include Support::Paypal::AdaptivePayments::Pay::Stub, type: :request
end
