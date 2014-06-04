require 'spec_helper.rb'

describe Api::PurchasesController do
  before { accept_json }
  let!(:user) { user = stub_token_authentication }

  describe "GET 'create'" do
    let(:tip) { FactoryGirl.create :tip }

    it "returns http success" do
      post :create, tip_id: tip.id, service: :itunes
      expect(response).to be_success
    end
  end

end
