require 'spec_helper'

describe Api::AuthController do
  let!(:user) { user = stub_token_authentication }
  let(:identity) { (user.identities << FactoryGirl.create(:identity)).first }
  let(:token) { identity.token }
  before { accept_json }

  include Support::Auth::OmniauthMocks

  describe '#after_sign_in_path_for' do

    before do
      request.env["omniauth.params"] = {}
      # todo: use a better way of mocking omniauth
      request.env["omniauth.auth"] = mock_facebook_omniauth
      request.env["omniauth.auth"].credentials.token = token
    end

    it 'appends the user token' do
      regex = /token=#{token}$/
      expect(subject.send :after_sign_in_path_for, user).to match regex
    end

    it 'returns redirect_to omniauth param if one is provided' do
      request.env["omniauth.params"] = { redirect_to: 'http://www.google.com' }
      url = "http://www.google.com?token=#{token}"
      expect(subject.send :after_sign_in_path_for, user).to eq url
    end

    it 'returns profile_url by default' do
      url = subject.profile_url + "?token=#{token}"
      expect(subject.send :after_sign_in_path_for, user).to eq url
    end

  end
end
