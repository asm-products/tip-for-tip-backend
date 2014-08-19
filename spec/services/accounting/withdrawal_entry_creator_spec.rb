require 'spec_helper.rb'

module Accounting
  describe WithdrawalEntryCreator do
    before { Accounts.seed }
    let(:withdrawal) { FactoryGirl.create :withdrawal }
    subject { WithdrawalEntryCreator.new.call(withdrawal) }

    it 'raises ArgumentError if no withdrawal is provided' do
      expect{ WithdrawalEntryCreator.new.call(nil) }.to raise_error(ArgumentError)
    end

    context 'when the withdrawal doesn\'t yet have a withdrawal entry' do
      before do
        expect(withdrawal.withdrawal_entry).to be_nil
      end

      it 'creates a withdrawal entry for the withdrawal' do
        expect{ subject }.to change(WithdrawalEntry, :count).by 1
        expect(withdrawal.withdrawal_entry).to_not be_nil
        expect(withdrawal.changed?).to be_falsey
      end
    end

    context 'when the withdrawal already has a withdrawal entry' do
      before do
        WithdrawalEntryCreator.new.call withdrawal
        expect(withdrawal.withdrawal_entry).to_not be_nil
        # Set credit and debit amounts to values that will be updated.
        withdrawal.withdrawal_entry.debit_amounts.update_all amount: 10000
        withdrawal.withdrawal_entry.credit_amounts.update_all amount: 10000
        withdrawal.withdrawal_entry.debit_amounts.to_a.slice(1, 100).each &:delete
        withdrawal.withdrawal_entry.credit_amounts.to_a.slice(1, 100).each &:delete
        expect(withdrawal.withdrawal_entry).to be_valid
      end

      it 'updates the withdrawal entry' do
        expect_any_instance_of(EntryUpdater).to receive :call
        subject
      end

      it 'updates the withdrawal entry that already exists' do
        expect{ subject }.to_not change(withdrawal, :withdrawal_entry_id)
      end

      it 'updates the entry with new debit amount records' do
        expect{ subject }.to change{ withdrawal.withdrawal_entry.debit_amounts.pluck(:id) }
      end

      it 'updates the entry with new credit amount records' do
        expect{ subject }.to change{ withdrawal.withdrawal_entry.credit_amounts.pluck(:id) }
      end

    end
  end
end
