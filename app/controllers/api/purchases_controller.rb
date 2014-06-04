class Api::PurchasesController < ApiController
  before_filter :authenticate_user_from_token!

  def create
    # temporary:
    render status: 201, nothing: true
  end
end
