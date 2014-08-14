require 'spec_helper.rb'

module Accounting
  describe EntryUpdater do
    let(:account1) { FactoryGirl.create :asset_account }
    let(:account2) { FactoryGirl.create :asset_account }
    let(:initial_amount) { 2 }
    let(:updated_amount) { 5 }
    let!(:entry) do
      entry = Plutus::Entry.build description: "foo",
        debits:  [{ account: account1.name, amount: initial_amount }],
        credits: [{ account: account2.name, amount: initial_amount }]
      entry.save!
      entry
    end
    let(:amounts) do
      {
        debit_amounts:  Plutus::DebitAmount.new( account: account1, amount: updated_amount),
        credit_amounts: Plutus::CreditAmount.new(account: account2, amount: updated_amount)
      }
    end
    subject { EntryUpdater.new.call(entry, amounts) }

    it { expect(entry).to be_valid }

    it 'raises ArgumentError if the entry is not a Plutus::Entry' do
      expect{ EntryUpdater.new.call(nil, amounts) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError if the entry is not persisted' do
      expect{ EntryUpdater.new.call(Plutus::Entry.new, amounts) }.to raise_error(ArgumentError)
    end

    it 'updates the entry that already exists' do
      expect{ subject }.to_not change{ Plutus::Entry.exists?(entry.id) }
    end

    it 'updates the entry with the new debit amount' do
      subject
      expect(entry.reload.debit_amounts.first.amount).to eq updated_amount
    end

    it 'updates the entry with the new credit amount' do
      subject
      expect(entry.reload.credit_amounts.first.amount).to eq updated_amount
    end

    it 'updates the entry with new debit amount records' do
      expect{ subject }.to change{ entry.reload.debit_amounts.pluck(:id) }
    end

    it 'updates the entry with new credit amount records' do
      expect{ subject }.to change{ entry.reload.credit_amounts.pluck(:id) }
    end

    it 'removes the previous amount records' do
      ids =  entry.debit_amounts.pluck(:id)
      ids += entry.credit_amounts.pluck(:id)
      subject
      expect(Plutus::Amount.where(id: ids).count).to eq 0
    end

    it 'effectively changes the account1 balance' do
      expect{ subject }.to change{ account1.reload.balance.to_f }.from(initial_amount).to(updated_amount)
    end

    it 'effectively changes the account2 balance' do
      expect{ subject }.to change{ account2.reload.balance.to_f }.from(-initial_amount).to(-updated_amount)
    end
  end
end
