require 'spec_helper.rb'

describe WithdrawCash do
  before { Accounts.seed }
  before do
    # Stub the remote request
    allow(paypal_api).to receive(:pay).and_return paypal_response
    # Stub the user's account balance.
    allow_any_instance_of(CustomerAccount).to receive(:balance).and_return account_balance
  end

  let(:instance) { WithdrawCash.new }
  let(:paypal_api) { instance.send :paypal_api }
  let(:user) { FactoryGirl.create :user }
  subject{ instance.(user) }

  let(:account_balance) { 50 }
  let(:withdrawal_amount) { 33.55 }
  let(:paypal_response) do
    PayPal::SDK::AdaptivePayments::DataTypes::PayResponse.new responseEnvelope: {
        timestamp: 10.seconds.ago,
        ack: "Success",
        correlationId: SecureRandom.hex(3),
      },
      payKey: SecureRandom.hex(3),
      success?: true,
      paymentExecStatus: "COMPLETED",
      paymentInfoList: {
        paymentInfo: [
          {
            pendingRefund: false,
            receiver: {
              accountId: SecureRandom.hex(3),
              amount: withdrawal_amount,
              email: user.email,
              primary: false
            },
            senderTransactionId: SecureRandom.hex(3),
            senderTransactionStatus: "COMPLETED",
            transactionId: SecureRandom.hex(3),
            transactionStatus: "COMPLETED"
          }
        ]
      },
      sender: {
        accountId: SecureRandom.hex(3)
      }
  end

  it 'defaults the amount to the amount of cash the user has in their account' do
    allow(user.customer_account).to receive(:balance).and_return withdrawal_amount
    expect(subject.amount).to eq withdrawal_amount
  end

  it 'creates a withdrawal instance' do
    expect{ subject }.to change(Withdrawal, :count).by 1
  end

  it 'creates a WithdrawalEntry instance' do
    expect{ subject }.to change(WithdrawalEntry, :count).by 1
  end

  it 'sets the WithdrawalEntry amounts to the correct value' do
    entry = subject.withdrawal_entry
    expect(account_balance).to eq Plutus::DebitAmount.where(id: entry.debit_amount_ids).sum(:amount)
    expect(account_balance).to eq Plutus::CreditAmount.where(id: entry.credit_amount_ids).sum(:amount)
  end

  it 'returns the created withdrawal' do
    expect(subject).to be_a_kind_of Withdrawal
  end

  it 'withdraws the maximum amount permissible if no amount is specified' do
    expect(subject.amount).to eq account_balance
  end

  context 'when the user has a lower balance than the allowed minimum' do
    let(:account_balance) { 9 }
    it { expect{ subject }.to raise_error ArgumentError }
  end

  context 'if an amount is specified' do
    let(:amount) { 17.44 }
    subject { instance.(user, amount: amount) }

    it 'sets the amount to the receiver' do
      expect(paypal_api).to receive(:pay) { |request|
        expect(request.receiverList.receiver.first.amount).to eq amount
      }.and_return(paypal_response)
      subject
    end

    context 'that is larger than the account balance' do
      let(:amount) { account_balance + 1 }
      it { expect{ subject }.to raise_error ArgumentError }
    end

    it 'sets the WithdrawalEntry amounts to the correct value' do
      entry = subject.withdrawal_entry
      expect(amount).to eq Plutus::DebitAmount.where(id: entry.debit_amount_ids).sum(:amount)
      expect(amount).to eq Plutus::CreditAmount.where(id: entry.credit_amount_ids).sum(:amount)
    end
  end

  describe 'the payment request to paypal' do

    it 'is made' do
      expect(paypal_api).to receive(:pay).and_return(paypal_response)
      subject
    end

    it 'sets the amount to the receiver' do
      expect(paypal_api).to receive(:pay) { |request|
        expect(request.receiverList.receiver.first.amount).to eq account_balance
      }.and_return(paypal_response)
      subject
    end

    it 'uses the user\'s paypal_email' do
      user.update_attributes! paypal_email: "foo#{SecureRandom.hex(3)}@bar.com"
      expect(paypal_api).to receive(:pay) { |request|
        expect(request.receiverList.receiver.first.email).to eq user.paypal_email
      }.and_return(paypal_response)
      subject
    end

    it 'uses the user\'s email if their paypal_email isn\'t set' do
      user.update_attributes! paypal_email: nil
      expect(paypal_api).to receive(:pay) { |request|
        expect(request.receiverList.receiver.first.email).to eq user.email
      }.and_return(paypal_response)
      subject
    end

    context 'if unsuccessful' do
      let(:paypal_response) do
        PayPal::SDK::AdaptivePayments::DataTypes::PayResponse.new responseEnvelope: {
            timestamp: 10.seconds.ago,
            ack: "Failure",
            correlationId: SecureRandom.hex(3),
          },
          error: [{
            errorId:   580001,
            domain:    "PLATFORM",
            subdomain: "Application",
            severity:  "Error",
            category:  "Application",
            message:   "Invalid request: More than one field cannot be used to specify a sender"
          }]
      end
      it { expect{ subject }.to raise_error Errors::PaypalPayment }
    end

  end

end
