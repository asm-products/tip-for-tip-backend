# https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
#
# Granted this strategy 1 isn't as secure as Jose would like us
# to have it. But it suits us for now.
module TokenAuthentication
  extend ActiveSupport::Concern

  private

  # Internal:
  # Authenticate the user via a provided token in either the
  # params or in a header.
  # Returns the user if found and signed in.
  # Returns false if the user was not found or signed in.
  def authenticate_user_from_token

    # Try first from the header. We use Rails' built in support
    # for http token authentication.
    # http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Token.html
    user = authenticate_with_http_token do |token, options|
      find_current_user_by_token(token, options) || false
    end

    # authenticate_with_http_token returns nil if no token was
    # provided. If nil, we'll pull a token from the params and use
    # strong_params to enforce its presence.
    if user.nil? && token = params[:token].presence
      # Find the user from param token
      user = find_current_user_by_token token
    end

    if user
      logger.debug "Authenticated user using token: #{user.id}"
      # Sign the user in but don't store an auth cookie.
      sign_in user, store: false
    end

    user || false
  end

  # Internal:
  # Same as `authenticate_user_from_token` but raises an exception
  # if authentication was unsuccessful.
  def authenticate_user_from_token!
    authenticate_user_from_token || raise(Errors::Unauthorized)
    # authenticate_user_from_token || throw(:warden)
  end

  def find_current_user_by_token(token, options={})
    identity = Identity.with_unexpired_token.find_by token: token
    identity.user if identity
  end

end
