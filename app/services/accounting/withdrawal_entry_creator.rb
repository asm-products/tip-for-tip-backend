module Accounting
  class WithdrawalEntryCreator

    # Creates a withdrawal entry and saves it to the withdrawal instance. Will only
    # create the entry if one does not already exist. If one does exist, it will replace
    # the entry's debits and credits entries with newly calculated ones.
    # All data changing calls will raise exceptions if errors occur, such as
    # validation errors.
    def call(withdrawal)
      @withdrawal = withdrawal
      raise ArgumentError, 'A withdrawal instance must be provided' unless @withdrawal.is_a?(Withdrawal)

      @entry = @withdrawal.withdrawal_entry || WithdrawalEntry.new
      @entry.description = "Withdrawal of cash. Transaction id: #{@withdrawal.transaction_id}"

      if @entry.persisted?
        # Update an entry
        EntryUpdater.new.call(@entry, amounts)
      else
        # Create an entry
        @entry.attributes = amounts.merge(withdrawal: @withdrawal)
        @entry.save!
        @withdrawal.update_attributes! withdrawal_entry: @entry
      end
      @entry
    end

    private

    # Internal. Build debit and credit amount instances.
    # Returns a hash with :debit_amounts and :credit_amounts keys.
    def amounts
      debit_account = Plutus::Account.find_by_name @withdrawal.user.customer_account.name
      credit_account = Plutus::Account.find_by_name Accounts::CASH

      {
        debit_amounts: [Plutus::DebitAmount.new(account: debit_account, amount: @withdrawal.amount, entry: @entry)],
        credit_amounts: [Plutus::CreditAmount.new(account: credit_account, amount: @withdrawal.amount, entry: @entry)]
      }
    end
  end
end
