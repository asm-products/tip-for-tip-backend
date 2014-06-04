require 'spec_helper.rb'

describe Api::UsersController do
  before { accept_json }
  let!(:user) { user = stub_token_authentication }

  describe 'profile' do

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    # Success
    it 'responds with success' do
      get :profile
      expect(response.status).to eq 200
    end

  end
end
