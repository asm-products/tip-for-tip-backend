require 'spec_helper'

describe Api::WithdrawalsController do
  before { accept_json }
  let!(:user) { stub_token_authentication }

  describe "GET 'create'" do
    before { Accounts.seed }
    before { stub_paypal_pay! }
    before { allow(user.customer_account).to receive(:balance).and_return account_balance }

    let(:account_balance) { 50 }
    let(:params) do
      { amount: 50 }
    end

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    it "uses withdraw_cash service" do
      expect_any_instance_of(WithdrawCash).to receive :call
      post :create, params
    end

    # Success
    it "responds with 201 created" do
      post :create, params
      expect(response.status).to be 201
    end

    it "creates a Withdrawal instance" do
      expect{ post :create, params }.to change{ Withdrawal.count }.by 1
    end

    # Bad requests
    context 'when the amount requested is not permissible' do
      let(:params) { {amount: 1} }

      it "responds with 400 bad request" do
        post :create, params
        expect(response.status).to eq 400
      end
    end

    # Paypal Failure
    context 'when the paypal request fails' do
      before { stub_paypal_pay_failure! }

      it 'responds with 503 service unavailable' do
        post :create, params
        expect(response.status).to be 503
      end

      it 'sends an error to rollbar' do
        expect(Rollbar).to receive(:report_exception).with an_instance_of(Errors::PaypalPayment), anything(), anything()
        post :create, params
      end
    end

  end

end
