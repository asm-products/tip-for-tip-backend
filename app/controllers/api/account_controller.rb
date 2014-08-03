class Api::AccountController < ApiController
  before_filter :authenticate_user_from_token!

  def balance
    @account_balance = current_user.account_balance
  end

  def purchases
    @purchases = current_user.purchases.order(:created_at).reverse_order
  end

  def sales
    @sales = current_user.sales.order(:created_at).reverse_order
  end

end
