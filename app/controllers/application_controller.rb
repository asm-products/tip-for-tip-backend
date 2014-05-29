class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Errors
  rescue_from Errors::Unauthorized, with: :error_401
  rescue_from ActiveRecord::RecordNotFound, with: :error_404

  def error_401
    # TODO: better response error message
    render status: :unauthorized, json: { error: :unauthorized}
  end

  def error_404
    # TODO: better response error message
    render status: :not_found, json: { error: :not_found }
  end

end
