module Support
  module Auth

    def self.setup_user(user, options={})
      if user.is_a?(Hash)
        options = user.symbolize_keys.reverse_merge options.symbolize_keys
        user = nil
      end

      if user.nil?
        if options[:admin]
          user = FactoryGirl.create(:admin_user)
        else
          user = FactoryGirl.create(:user)
        end
      end

      [user, options]
    end

    module Omniauth

      def omniauth_from_identity(identity)
        auth = FactoryGirl.attributes_for "#{identity.provider}_omniauth",
          provider: identity.provider,
          uid: identity.uid
        auth[:credentials][:expires_at] = identity.token_expires_at.to_i
        auth[:credentials][:token] = identity.token
        OmniAuth::AuthHash.new auth
      end

      module Mocks

        # TODO: add support for customizing the user to log in

        def mock_facebook_omniauth
          OmniAuth.config.mock_auth[:facebook] = FactoryGirl.build :facebook_omniauth
        end

        def mock_twitter_omniauth
          OmniAuth.config.mock_auth[:facebook] = FactoryGirl.build :facebook_omniauth
        end

      end
    end


    module Controller

      def login(user=nil, options={})
        request.env["devise.mapping"] = Devise.mappings[:user]
        user, options = ::Support::Auth.setup_user(user, options)
        sign_in user
        allow(controller).to receive(:current_user).and_return(user)
        user
      end

      def stub_token_authentication(user=nil, options={})
        user, options = ::Support::Auth.setup_user(user, options)
        allow(controller).to receive(:authenticate_user_from_token).and_return(:user)
        controller.sign_in user, store: false
        user
      end

      # def stub_doorkeeper(user = nil, token = nil)
      #   allow(controller).to receive(:doorkeeper_token) { token || double(:accessible? => true) }
      #   allow(controller).to receive(:current_resource_owner) { user || FactoryGirl.create(:group_member) }
      # end
    end

    module Feature

      def login(options={})
        options.symbolize_keys!
        options[:provider] = (options[:provider] || :facebook).to_sym
        visit "/auth/#{options[:provider]}"

        email = OmniAuth.config.mock_auth[options[:provider]].info.email
        body = JSON.parse page.source
        expect(body["email"]).to eq email

        OmniAuth.config.mock_auth[options[:provider]]
      end
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller

  OmniAuth.config.test_mode = true
  # OmniauthMocks module methods add provider specific auth objects to the
  # OmniAuth mock object.
  config.include Support::Auth::Omniauth
  config.include Support::Auth::Omniauth::Mocks

  config.include Support::Auth::Controller, type: :controller
  # config.include Support::Auth::Request, type: :request
  config.include Support::Auth::Feature, type: :feature
end
