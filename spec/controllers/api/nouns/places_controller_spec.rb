require 'spec_helper'
include Support::FoursquareMock

describe Api::Nouns::PlacesController do
  let!(:user) { user = stub_token_authentication }
  before { accept_json }

  describe '#show' do

    context 'if found' do
      let(:place) { FactoryGirl.create :place }

      it 'can find by id' do
        get :show, place_id: place.id
        expect(response.status).to eq 200
      end

      it 'can find by uuid' do
        get :show, place_id: place.uuid
        expect(response.status).to eq 200
      end

      it 'responds successfully' do
        get :show, place_id: place.id
        expect(response.status).to eq 200
      end

      it 'assigns the place' do
        get :show, place_id: place.id
        expect(assigns :place).to eq place
      end
    end

    context 'if not found' do

      it 'responds with 404' do
        get :show, place_id: 0
        expect(response.status).to eq 404
      end

    end

  end

  describe '#foursquare_show' do

    context 'if found' do
      let(:place) { FactoryGirl.create :place }

      it 'responds successfully' do
        get :foursquare_show, foursquare_id: place.foursquare_id
        expect(response.status).to eq 200
      end

      it 'assigns the place' do
        get :foursquare_show, foursquare_id: place.foursquare_id
        expect(assigns :place).to eq place
      end
    end

    context 'if not found' do
      let!(:venue_id) { mock_foursquare_venue[:id] }

      it 'fetches data from foursquare and creates a place' do
        expect{ get :foursquare_show, foursquare_id: venue_id }
          .to change{ Nouns::Place.count }.by 1
      end

      it 'responds with 201 created' do
        get :foursquare_show, foursquare_id: venue_id
        expect(response.status).to eq 201
      end

      context 'and no data is found on foursquare' do
        let!(:venue_id) { mock_foursquare_venue_not_found[:id] }

        it 'responds with 404' do
          get :foursquare_show, foursquare_id: venue_id
          expect(response.status).to eq 404
        end

      end

    end

  end

end
