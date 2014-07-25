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

  end



end
