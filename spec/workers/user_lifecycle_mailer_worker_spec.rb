require 'spec_helper'

describe UserLifecycleMailerWorker do
  it { expect(subject).to be_retryable true }
  it { expect(subject).to be_processed_in :email }

  describe '.perform' do
    subject { UserLifecycleMailerWorker.new.perform :foo, user.id }
    let(:user) { create :user }
    let(:email) { double deliver: true }

    it 'creates a mailer' do
      expect(UserLifecycleMailer).to receive(:send).with(:foo, user).and_return email
      subject
    end

    it 'delivers an email' do
      allow(UserLifecycleMailer).to receive(:send).and_return email
      expect(email).to receive(:deliver).once
      subject
    end
  end
end
