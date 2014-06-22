require 'spec_helper'

describe Identity do

  it { expect(FactoryGirl.build :identity).to be_valid }

  it { should validate_uniqueness_of(:user_id).scoped_to :provider  }
  it { should validate_uniqueness_of :token }

  it 'nilifies its token after find if token is expired' do
    identity = FactoryGirl.create :identity, token_expires_at: 5.minutes.ago
    expect_any_instance_of(Identity).to receive(:update_attributes!).with hash_including(token: nil)
    Identity.find(identity.id)
  end

  describe '.with_expired_token' do
    it 'returns identities with expired and null tokens' do
      identities = [
        FactoryGirl.create(:identity, token_expires_at: 5.minutes.ago),
        FactoryGirl.create(:identity, token_expires_at: nil)
      ]
      FactoryGirl.create :identity, token_expires_at: 5.minutes.from_now
      expect(Identity.with_expired_token.pluck(:id).sort).to eq identities.collect(&:id).sort
    end
  end

  describe '.with_unexpired_token' do
    it 'returns identities with unexpired tokens' do
      identities = [
        FactoryGirl.create(:identity, token_expires_at: 5.minutes.from_now)
      ]
      FactoryGirl.create(:identity, token_expires_at: 5.minutes.ago)
      FactoryGirl.create(:identity, token_expires_at: nil)
      expect(Identity.with_unexpired_token.pluck(:id).sort).to eq identities.collect(&:id).sort
    end
  end

end
