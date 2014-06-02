require 'spec_helper'

describe Api::PartnersController do
  before { accept_json }

  describe "GET 'show'" do
    let(:partner) { FactoryGirl.create :partner, primary_user: user }
    let!(:user) { user = stub_token_authentication }

    it "returns http success" do
      get :show, partner_id: partner.id
      p response.body
      expect(response.status).to eq 200
    end

    context 'if the resource id does not exist' do
      it "returns 404 " do
        get :show, partner_id: 0
        expect(response.status).to eq 404
      end
    end

    it "returns 401 if the user cannot view the resource" do
      other_user = FactoryGirl.create :user
      stub_token_authentication other_user
      get :show, partner_id: partner.id
      expect(response.status).to eq 401
    end

  end

end
