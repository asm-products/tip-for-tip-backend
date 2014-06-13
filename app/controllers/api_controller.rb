# The base controller for API v1
class ApiController < ApplicationController
  include TokenAuthentication
  extend Memoist

  # Turn CSRF Off
  skip_before_filter :verify_authenticity_token

  # Errors
  rescue_from Errors::Unauthorized, with: :unauthorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # rescue_from ActionController::ParameterMissing #TODO: strong params rescue
  # rescue_from ActiveRecord::RecordInvalid #TODO 422 responses

  protected

  def unauthorized e=nil
    # TODO: better response error message
    render status: :unauthorized, json: { error: :unauthorized}
  end

  def not_found e=nil
    # TODO: better response error message
    render status: :not_found, json: { error: :not_found }
  end
end
