class Api::WithdrawalsController < ApiController
  before_filter :authenticate_user_from_token!

  rescue_from Errors::PaypalPayment, with: :paypal_error_response
  rescue_from Errors::WithdrawalError, with: :bad_request

  def create
    @withdrawal = WithdrawCash.new.(current_user, withdrawal_params.to_hash)
    render status: :created
  end

  private

  def withdrawal_params
    keys = %w{ amount }
    params.permit *keys
  end
  memoize :withdrawal_params

  def paypal_error_response(e)
    logger.error "Unexpected Paypal error during a withdrawal, responding with 503: \n#{e.message}\n#{e.backtrace.join("\n")}"
    Rollbar.report_exception(e, rollbar_request_data, rollbar_person_data)
    render status: 503, json: { error: :service_unavailable, message: "Due to the unavailability of Paypal, this service is temporarily unavailable." }
  end

end
