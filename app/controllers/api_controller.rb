# The base controller for API v1
class ApiController < ApplicationController
  include TokenAuthentication
  extend Memoist

  # Turn CSRF Off
  skip_before_filter :verify_authenticity_token

  # Errors
  rescue_from Errors::Unauthorized, with: :unauthorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def unauthorized
    # TODO: better response error message
    render status: :unauthorized, json: { error: :unauthorized}
  end

  def not_found
    # TODO: better response error message
    render status: :not_found, json: { error: :not_found }
  end
end
