require 'spec_helper.rb'

describe Api::PurchasesController do
  before { accept_json }
  let!(:user) { user = stub_token_authentication }

  it { permit(:tip_id).for(:create) }
  it { permit(:service).for(:create) }
  it { permit(:receipt_data).for(:create) }
  it { permit(:transaction_id).for(:create) }
  it { permit(:transaction_value).for(:create) }
  it { permit(:transaction_currency).for(:create) }
  it { permit(:transaction_timestamp).for(:create) }
  it { should filter_param(:receipt_data) }

  describe "GET 'create'" do
    let(:tip) { FactoryGirl.create :tip }
    let(:valid_params) do
      {
        receipt_data: "encrypted receipt data",
        transaction_id: '1',
        transaction_value: '99',
        transaction_currency: 'USD',
        transaction_timestamp: 10.minutes.ago.to_time.iso8601,
        # url params
        tip_id: tip.id,
        service: :itunes
      }
    end

    it "returns http success" do
      post :create, valid_params
      expect(response.status).to be 201
    end

    it "finds the tip by id" do
      post :create, valid_params
      expect(response).to be_success
    end

    it "finds the tip by uuid" do
      post :create, valid_params.merge(tip_id: tip.uuid)
      expect(response).to be_success
    end

    it "creates a Purchase instance" do
      expect{ post :create, valid_params }.to change{ Purchase.count }.by 1
    end

  end
end
