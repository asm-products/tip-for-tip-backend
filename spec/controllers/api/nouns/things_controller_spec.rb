require 'spec_helper'

describe Api::Nouns::ThingsController do
  let!(:user) { user = stub_token_authentication }
  before { accept_json }

  describe '#show' do

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    context 'if found' do
      let(:thing) { FactoryGirl.create :thing }

      it 'can find by id' do
        get :show, thing_id: thing.id
        expect(response.status).to eq 200
      end

      it 'can find by uuid' do
        get :show, thing_id: thing.uuid
        expect(response.status).to eq 200
      end

      it 'responds successfully' do
        get :show, thing_id: thing.id
        expect(response.status).to eq 200
      end

      it 'assigns the thing' do
        get :show, thing_id: thing.id
        expect(assigns :thing).to eq thing
      end
    end

    context 'if not found' do

      it 'responds with 404' do
        get :show, thing_id: 0
        expect(response.status).to eq 404
      end

    end
  end

  describe '#create' do
    let(:params) { { name: "Tip for Tip" } }

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    describe 'params' do
      it { should permit(:name).for :create }
    end

    describe 'creating the thing' do
      subject { post :create, params }

      it 'creates a Nouns::Thing record' do
        expect{ subject }.to change{ Nouns::Thing.count }.by 1
      end

      it 'creates a NounCreator record' do
        expect{ subject }.to change{ NounCreator.count }.by 1
      end

      it 'renders the show view' do
        expect(subject).to render_template :show
      end
    end

  end
end
