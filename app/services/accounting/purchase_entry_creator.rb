module Accounting
  class PurchaseEntryCreator

    # Creates a purchase entry and saves it to the purchase. Will only create
    # the entry if one does not already exist. If one does exist, it will replace
    # the entry's debits and credits entries with newly calculated ones.
    # All data changing calls will raise exceptions if errors occur, sucha as
    # validation errors.
    def call(purchase)
      @purchase = purchase
      raise ArgumentError, 'A purchase must be provided' unless @purchase.is_a?(Purchase)
      @entry = @purchase.purchase_entry || PurchaseEntry.new
      @entry.description = "Purchase of tip #{@purchase.tip.id}"

      if @entry.persisted?
        # Update an entry
        EntryUpdater.new.call(@entry, amounts)
      else
        # Create an entry
        @entry.attributes = amounts.merge(purchase: @purchase)
        @entry.save!
        purchase.update_attributes! purchase_entry: @entry
      end
      @entry
    end

    private

    # Internal. Build debit and credit amount instances based on the correct
    # service and pricing calculations.
    # Returns a hash with :debit_amounts and :credit_amounts keys.
    def amounts
      case @purchase.service.to_sym
      when :itunes
        {
          debit_amounts: itunes_debits,
          credit_amounts: itunes_credits
        }
      else
        raise NotImplementedError
      end
    end

    def itunes_debits
      [
        { account: Accounts::CASH,            amount: 0.69 }, # Cash we control
        { account: Accounts::ITUNES_IAP_FEES, amount: 0.30 }  # The fee is already paid
      ].collect do |debit|
        a = Plutus::Account.find_by_name(debit[:account])
        Plutus::DebitAmount.new(account: a, amount: debit[:amount], entry: @entry)
      end
    end

    def itunes_credits
      [
        { account: @purchase.tip.user.customer_account.name, amount: 0.50 }, # We owe the creator this much
        { account: Accounts::PURCHASE_REVENUE,               amount: 0.49 }  # The rest is our gross revenue
      ].collect do |credit|
        a = Plutus::Account.find_by_name(credit[:account])
        Plutus::CreditAmount.new(account: a, amount: credit[:amount], entry: @entry)
      end
    end

  end
end
