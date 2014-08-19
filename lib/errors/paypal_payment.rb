module Errors
  # Represents an error response when making a payment via paypal.
  class PaypalPayment < StandardError
    attr_accessor :request
    attr_accessor :response

    def initialize(response, request)
      response = response.first if response.is_a?(Array)
      @response = response
      @request = request
      super "#{response.message} (errorId: #{response.errorId})"
    end

    def error_id
      @response.errorId
    end
  end
end
