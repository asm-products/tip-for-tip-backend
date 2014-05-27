class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Errors
  rescue_from Errors::Unauthorized, with: :error_401

  def error_401
    render status: :unauthorized, nothing: true
  end

end
