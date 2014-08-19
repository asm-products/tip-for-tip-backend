require 'spec_helper.rb'

module Accounting
  describe PurchaseEntryCreator do
    before { Accounts.seed }
    let(:purchase) { FactoryGirl.create :purchase }
    subject { PurchaseEntryCreator.new.call(purchase) }

    it 'raises ArgumentError if no purchase is provided' do
      expect{ PurchaseEntryCreator.new.call(nil) }.to raise_error(ArgumentError)
    end

    context 'when the purchase doesn\'t yet have a purchase entry' do
      before do
        expect(purchase.purchase_entry).to be_nil
      end

      it 'creates a purchase entry for the purchase' do
        expect{ subject }.to change(PurchaseEntry, :count).by 1
        expect(purchase.purchase_entry).to_not be_nil
        expect(purchase.changed?).to be_falsey
      end
    end

    context 'when the purchase already has a purchase entry' do
      before do
        PurchaseEntryCreator.new.call purchase
        expect(purchase.purchase_entry).to_not be_nil
        # Set credit and debit amounts to values that will be updated.
        purchase.purchase_entry.debit_amounts.update_all amount: 10000
        purchase.purchase_entry.credit_amounts.update_all amount: 10000
        purchase.purchase_entry.debit_amounts.to_a.slice(1, 100).each &:delete
        purchase.purchase_entry.credit_amounts.to_a.slice(1, 100).each &:delete
        expect(purchase.purchase_entry).to be_valid
      end

      it 'updates the purchase entry' do
        expect_any_instance_of(EntryUpdater).to receive :call
        subject
      end

      it 'updates the purchase entry that already exists' do
        expect{ subject }.to_not change(purchase, :purchase_entry_id)
      end

      it 'updates the entry with new debit amount records' do
        expect{ subject }.to change{ purchase.purchase_entry.debit_amounts.pluck(:id) }
      end

      it 'updates the entry with new credit amount records' do
        expect{ subject }.to change{ purchase.purchase_entry.credit_amounts.pluck(:id) }
      end

    end
  end
end
