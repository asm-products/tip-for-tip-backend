module FoursquareClient
  extend ActiveSupport::Concern

  private

  def foursquare_client
    options = foursquare_credentials.merge api_version: '20140520'
    @foursquare_client ||= Foursquare2::Client.new options
  end

  def foursquare_credentials
    @foursquare_creds ||= {
      client_id: Rails.application.secrets.foursquare['client_id'],
      client_secret: Rails.application.secrets.foursquare['client_secret']
    }
  end

end
