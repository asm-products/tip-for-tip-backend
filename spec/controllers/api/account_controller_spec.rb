require 'spec_helper.rb'

describe Api::AccountController do
  before { accept_json }
  let!(:user) { user = stub_token_authentication }

  describe '#purchases' do

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    # Success
    it 'responds with success' do
      get :purchases
      expect(response.status).to eq 200
    end

    it 'renders the purchases view' do
      expect(get :purchases).to render_template :purchases
    end

  end
end
