# require 'spec_helper.rb'

# describe "Auth Requests" do

#   describe "/auth/logout" do

#     before do
#       OmniAuth.config.test_mode = true
#       provider = 'facebook'
#       OmniAuth.config.mock_auth[provider.to_sym] = FactoryGirl.build :facebook_omniauth

#     #   auth_data = login
#     #   # @request.env["omniauth.auth"] = auth_data
#       request.env["devise.mapping"] = Devise.mappings[:user]
#       request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider.to_sym]
#     end

#     before do


#     end


#     it "logs the current user out" do

#       # p request
#       # p @request
#       # p self

#       get '/auth/facebook'

#       get '/profile'
#       expect(response.status).to eq 200
#       get '/auth/logout'
#       expect(response.status).to eq 401
#     end

#   end

# end
