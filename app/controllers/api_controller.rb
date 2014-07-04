# The base controller for API v1
class ApiController < ApplicationController
  include TokenAuthentication
  extend Memoist

  # Turn CSRF Off
  skip_before_filter :verify_authenticity_token

  # Errors
  rescue_from Exception, with: :server_error # Catchall
  # rescue_from ActionController::ParameterMissing #TODO: strong params rescue
  # rescue_from ActiveRecord::RecordInvalid #TODO 422 responses
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Errors::Unauthorized, with: :unauthorized

  protected

  def unauthorized e=nil
    # TODO: better response error message
    render status: :unauthorized, json: { error: :unauthorized}
  end

  def not_found e=nil
    # TODO: better response error message
    render status: :not_found, json: { error: :not_found }
  end

  def server_error e=nil
    # TODO: better response error messages
    # TODO: submit errors from there to bugsnag or something similar.
    logger.error "Unexpected server error, responding with 500: \n#{e.message}\n#{e.backtrace}"
    Rollbar.report_exception(e)
    render status: 500, json: { error: :server_error, message: "Unexpected server error" }
  end

end
