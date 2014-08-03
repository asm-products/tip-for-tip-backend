require 'spec_helper.rb'

describe Api::PurchasesController do
  include Support::ItunesReceipts::VerificationMock

  before { accept_json }
  let!(:user) { user = stub_token_authentication }

  it { should filter_param(:receipt_data) }

  describe "GET 'create'" do
    let(:tip) { FactoryGirl.create :tip }
    let(:params) do
      {
        receipt_data: "encrypted receipt data",
        transaction_id: itunes_transaction_id,
        # transaction_timestamp: 10.minutes.ago.to_time.iso8601,
        tip_id: tip.id,
        service: :itunes
      }
    end
    before { stub_successful_itunes_receipt_verification }
    before { Accounts.seed }

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    it "uses itunes_purchase_creator service" do
      expect_any_instance_of(ItunesPurchaseCreator).to receive :call
      post :create, params
    end

    # Success
    it "returns http created when successful" do
      post :create, params
      expect(response.status).to be 201
    end

    it "finds the tip by id" do
      post :create, params.merge(tip_id: tip.id)
      expect(response).to be_success
    end

    it "finds the tip by uuid" do
      post :create, params.merge(tip_id: tip.uuid)
      expect(response).to be_success
    end

    it "creates a Purchase instance" do
      expect{ post :create, params }.to change{ Purchase.count }.by 1
    end

    # Verification failure
    context 'if the verification fails' do
      before { stub_unsuccessful_itunes_receipt_verification }

      it 'responds with 400' do
        post :create, params
        expect(response.status).to eq 400
      end

      it 'still creates a verification instance' do
        expect{ post :create, params }.to change{ IapReceiptVerification.count }.by 1
      end
    end
    context 'if the transaction is not in the decoded receipt' do
      before { params.merge! transaction_id: "NOT A VALID ID" }
      it 'responds with 400' do
        post :create, params
        expect(response.status).to eq 400
      end

      it 'still creates a verification instance' do
        expect{ post :create, params }.to change{ IapReceiptVerification.count }.by 1
      end
    end

  end

  describe '#purchase_params' do
    # it { should permit(:tip_id).for(:create, params: params, verb: :post) }
    # it { should permit(:service).for(:create, params: params, verb: :post) }
    # it { should permit(:receipt_data).for(:create, params: params, verb: :post) }
    # it { should permit(:transaction_id).for(:create, params: params, verb: :post) }
    # it { should permit(:transaction_value).for(:create, params: params, verb: :post) }
    # it { should permit(:transaction_currency).for(:create, params: params, verb: :post) }
    # it { should permit(:transaction_timestamp).for(:create, params: params, verb: :post) }
  end

end
