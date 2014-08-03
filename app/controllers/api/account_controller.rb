class Api::AccountController < ApiController
  before_filter :authenticate_user_from_token!

  def purchases
    @purchases = current_user.purchases
  end

end
