require 'spec_helper.rb'

describe ItunesPurchaseCreator do
  include Support::ItunesReceipts::VerificationMock
  before { stub_successful_itunes_receipt_verification }
  before { Accounts.seed }

  let(:user) { FactoryGirl.create :user }
  let(:tip)  { FactoryGirl.create :tip  }
  subject{ ItunesPurchaseCreator.new.(user, tip, itunes_transaction_id, "encoded receipt") }

  it 'creates a purchase instance' do
    expect{ subject }.to change(Purchase, :count).by 1
  end

  it 'creates a purchase_entry instance' do
    expect{ subject }.to change(PurchaseEntry, :count).by 1
  end

  it 'creates an IapReceiptVerification instance' do
    expect{ subject }.to change{ IapReceiptVerification.count }.by 1
  end

  it 'returns the created purchase' do
    expect(subject).to be_a_kind_of Purchase
  end

  context 'if the verification is not successful' do
    before{ stub_unsuccessful_itunes_receipt_verification }

    it 'does not create a purchase' do
      expect{ subject }.to_not change{ Purchase.count }
    end

    it 'returns false' do
      expect(subject).to eq false
    end

    it 'creates an verification instance' do
      expect{ subject }.to change{ IapReceiptVerification.count }.by 1
    end

    it 'sets the verification as unsuccessful' do
      subject
      expect(IapReceiptVerification.last.successful).to eq false
    end
  end

  context 'if the transaction_id is not found in the decoded receipt' do
    subject{ ItunesPurchaseCreator.new.(user, tip, "not the correct transaction id", "encoded receipt") }

    it 'does not create a purchase' do
      expect{ subject }.to_not change{ Purchase.count }
    end

    it 'returns false' do
      expect(subject).to eq false
    end

    it 'creates an verification instance' do
      expect{ subject }.to change{ IapReceiptVerification.count }.by 1
    end

    it 'sets the verification as unsuccessful' do
      subject
      expect(IapReceiptVerification.last.successful).to eq false
    end

  end

end
