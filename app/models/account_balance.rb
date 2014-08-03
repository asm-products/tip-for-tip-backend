# Calculates and represents a user's cash account balance and
# related information.
class AccountBalance
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def balance
    user.customer_account.balance
  end

  def purchases_count
    user.purchases.count
  end

  def sales_count
    user.sales.count
  end
end
