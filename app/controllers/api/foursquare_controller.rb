module Api
  class FoursquareController < ApplicationController
    before_filter :authenticate_user!

    # Rescues
    # TODO: look up foursquare api errors and make sure we're handling all
    # of them correctly. FOR NOW, its just responding with 500.
    # rescue_from Foursquare2::APIError, with: :handle_foursquare_api_error

    # Actions
    def proxy

      # Strip out any version segments since the client assumes V2
      foursquare_path = params[:foursquare_path].gsub(/^v[0-9]\//i, '')

      # We bypass the shortcut methods the client gem offers for us and
      # build a request the same way those methods do.
      foursquare_response = client.connection.get do |req|
        req.url foursquare_path, foursquare_params
      end
      body = client.return_error_or_body(foursquare_response, foursquare_response.body)

      # Get response headers that we care about
      response.headers.merge! foursquare_response.headers.slice('x-ratelimit-limit', 'x-ratelimit-remaining')

      render json: body
    end

    private

    # def handle_foursquare_api_error(e)

    # end

    def client
      @client ||= Foursquare2::Client.new foursquare_credentials
      # TODO: in the future when we have users authing via foursquare (saves us on ratelimits):
      # client = Foursquare2::Client.new(:oauth_token => 'user_oauth_token')
    end

    def foursquare_params
      params.except(:controller, :action, :foursquare_path, :format)
    end

    def foursquare_credentials
      @creds ||= {
        client_id: Rails.application.secrets.foursquare['client_id'],
        client_secret: Rails.application.secrets.foursquare['client_secret']
      }
    end
  end
end
