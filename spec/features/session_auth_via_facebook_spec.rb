require 'spec_helper.rb'

feature "Session login via Facebook" do

  before do
    mock_facebook_omniauth
  end

  scenario "login" do
    visit '/auth/facebook'
    email = OmniAuth.config.mock_auth[:facebook].info.email
    body = JSON.parse page.source
    expect(body["email"]).to eq email
  end

  scenario "logout" do
    login provider: :facebook
    visit '/auth/logout'
    visit '/profile'
    body = JSON.parse page.source
    expect(body["error"]).to_not eq nil
  end

end
