require 'spec_helper.rb'
include Support::FoursquareMock

describe Api::FoursquareController do
  before { accept_json }

  describe '#proxy request' do

    before { login }

    it "responds with the body of the foursquare response" do
      params = mock_foursquare_venue_search.merge foursquare_path: '/v2/venues/search'
      get :proxy, params
      expect(response.body).to eq Support::FoursquareMock::Responses.venue_search_body
    end

    it "appends foursquare ratelimit headers if they are present" do
      params = mock_foursquare_venue_search.merge foursquare_path: '/v2/venues/search'
      get :proxy, params
      expect(response.headers.keys).to include('x-ratelimit-limit', 'x-ratelimit-remaining')
    end

  end

end
