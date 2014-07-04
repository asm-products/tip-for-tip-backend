require 'spec_helper'

describe Api::TipsController do
  let!(:user) { user = stub_token_authentication }
  before { accept_json }

  describe '#show' do
    let(:tip) { FactoryGirl.create :tip }

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    it 'responds with success' do
      get :show, tip_id: tip.id
      expect(response).to be_success
    end

    it 'can find by id' do
      get :show, tip_id: tip.id
      expect(response).to be_success
    end

    it 'can find by uuid' do
      get :show, tip_id: tip.uuid
      expect(response).to be_success
    end

    it 'assigns the @tip' do
      get :show, tip_id: tip.id
      expect(assigns :tip).to eq tip
    end

    context 'if not found' do

      it 'responds with 404' do
        get :show, tip_id: 0
        expect(response.status).to eq 404
      end
    end
  end

  describe '#create for a place' do
    let(:params) do
      {
        noun_type: :place,
        noun_id: noun.id
      }.merge FactoryGirl.attributes_for(:tip)
    end
    let(:noun) { FactoryGirl.create :place }

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    describe 'finding the noun' do
      let(:noun) { FactoryGirl.create :place }

      it 'can find by id' do
        post :create, params.merge(noun_id: noun.id)
        expect(assigns :noun).to eq noun
      end

      it 'can find by uuid' do
        post :create, params.merge(noun_id: noun.uuid)
        expect(assigns :noun).to eq noun
      end

      it 'responds with 201 created' do
        post :create, params
        expect(response.status).to eq 201
      end
    end

    describe 'creating the tip' do
      subject { post :create, params }

      it 'creates a tip record' do
        expect{ subject }.to change{ Tip.count }.by 1
      end

      it 'assigns the current user to the tip' do
        subject
        expect(assigns(:tip).user).to eq user
      end

      it 'assigns the noun to the tip' do
        subject
        expect(assigns(:tip).noun).to eq noun
      end

      it 'renders the show view' do
        expect(subject).to render_template :show
      end
    end

    context 'if the noun is not not found' do
      it 'responds with 404' do
        post :create, params.merge(noun_id: 0)
        expect(response.status).to eq 404
      end
    end

    context 'if the place type is not a valid place type' do
      it 'responds with 404' do
        post :create, params.merge(noun_type: :NOT_A_VALID_PLACE_TYPE)
        expect(response.status).to eq 404
      end
    end

  end

  describe '#create for a thing noun' do
    let(:params) do
      {
        noun_type: :thing,
        noun_id: noun.id
      }.merge FactoryGirl.attributes_for(:tip)
    end
    let(:noun) { FactoryGirl.create :thing }

    # Auth
    it { should use_before_filter(:authenticate_user_from_token!) }

    describe 'finding the noun' do
      it 'can find by id' do
        post :create, params.merge(noun_id: noun.id)
        expect(assigns :noun).to eq noun
      end

      it 'can find by uuid' do
        post :create, params.merge(noun_id: noun.uuid)
        expect(assigns :noun).to eq noun
      end

      it 'responds with 201 created' do
        post :create, params
        expect(response.status).to eq 201
      end
    end

    describe 'creating the tip' do
      subject { post :create, params }

      it 'creates a tip record' do
        expect{ subject }.to change{ Tip.count }.by 1
      end

      it 'assigns the current user to the tip' do
        subject
        expect(assigns(:tip).user).to eq user
      end

      it 'assigns the noun to the tip' do
        subject
        expect(assigns(:tip).noun).to eq noun
      end

      it 'renders the show view' do
        expect(subject).to render_template :show
      end
    end

    context 'if the noun is not not found' do
      it 'responds with 404' do
        post :create, params.merge(noun_id: 0)
        expect(response.status).to eq 404
      end
    end

    context 'if the thing type is not a valid thing type' do
      it 'responds with 404' do
        post :create, params.merge(noun_type: :NOT_A_VALID_THING_TYPE)
        expect(response.status).to eq 404
      end
    end

  end
end
