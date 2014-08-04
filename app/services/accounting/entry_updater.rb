# A general purpose updater for account entries. Allows entry record
# to stay the same (leaving the important created_at value the same)
# while updating only the values associated to it. Updating an entry
# will destroy the old values instances.
#
# Takes `save!` action on the entry instance.
#
# Pass the debit_amounts and credit_amounts into the call as hash options:
# Example:
#   amounts = {
#     debit_amounts: [<Plutus::DebitAmount instance>],
#     credit_amounts: [<Plutus::CreditAmount instance>]
#   }
#   Accounting::EntryUpdater.new.call(existing_entry, amounts)
#
module Accounting
  class EntryUpdater

    def call(entry, options)
      @entry = entry
      raise ArgumentError unless @entry.is_a? Plutus::Entry
      raise ArgumentError unless @entry.persisted?
      options.symbolize_keys!
      amounts = options.slice(:debit_amounts, :credit_amounts)
      amounts.each { |k,v| amounts[k] = Array(v) }

      old_amounts_ids = Plutus::Amount.where(entry_id: @entry.id).pluck(:id)

      # Make sure our entry is assigned to each amount instance.
      amounts.each do |k, amounts_list|
        amounts_list.each do |amount|
          amount.entry = @entry
        end
      end

      # @entry.attributes = amounts
      @entry.debit_amounts  = amounts[:debit_amounts]
      @entry.credit_amounts = amounts[:credit_amounts]

      @entry.save!

      # Destroy the old amounts
      unless Plutus::Amount.delete_all(id: old_amounts_ids) == old_amounts_ids.count
        raise "Did not destroy all previous amount records"
      end

      @entry
    end

  end
end
