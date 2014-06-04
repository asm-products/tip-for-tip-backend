# Handles the creation of a purchase. Also verifies the receipt
# data before
class PurchaseCreator

  def call(user, tip, params)

    # TODO: VERIFY THE PURCHASE HERE.
    # TODO: STORE FAILED RECEPT DATA VALIDATIONS

    Purchase.create! params.merge(tip: tip, user: user)
  end

end
