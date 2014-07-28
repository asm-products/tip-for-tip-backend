require 'spec_helper'

describe OmniauthUserFinder do

  context 'when a user already has an account' do
    let!(:user) { FactoryGirl.create :user, :with_identity }
    let(:auth) { omniauth_from_identity user.identities.first }
    subject { OmniauthUserFinder.new.(auth) }

    it 'finds and returns the user' do
      expect(subject).to eq user
    end

  end

  context 'when a user does not have an account' do
    let(:auth) { omniauth_from_identity FactoryGirl.build(:identity, user: nil) }
    subject { OmniauthUserFinder.new.(auth) }

    it 'creates a user' do
      expect{ subject }.to change(User, :count).by 1
    end

    it 'creates an identity' do
      expect{ subject }.to change(Identity, :count).by 1
    end

    it 'returns the user' do
      expect(subject).to be_a_kind_of User
    end

  end
end
