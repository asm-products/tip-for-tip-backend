class Api::UsersController < ApiController
  before_filter :authenticate_user_from_token!

  def profile
  end

end
