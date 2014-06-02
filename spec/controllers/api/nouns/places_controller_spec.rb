require 'spec_helper'

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
        get :show, place_id: place.id
        expect(response.status).to eq 200
      end

      it 'assigns the place' do
        get :show, place_id: place.id
        expect(assigns :place).to eq place
      end
    end

    context 'if not found' do

    end

  end

end
