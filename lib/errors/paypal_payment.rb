module Errors
  # Represents an error response when making a payment via paypal.
  class PaypalPayment < StandardError

    def initialize(error_response)
      error_response = error_response.first if error_response.is_a?(Array)
      @data = error_response
      super "#{error_response.message} (errorId: #{error_response.errorId})"
    end

    def error_id
      @data.errorId
    end
  end
end
