require 'spec_helper'

describe UserLifecycleMailer do
  let(:user) { FactoryGirl.create(:user) }

  describe '#deliver' do
    it 'delivers the email' do
      expect{ UserLifecycleMailer.welcome(user).deliver }.to change{ MandrillMailer::deliveries.count }.by 1
    end
  end

  describe '.welcome' do

    it 'creates a mailer object' do
      expect(UserLifecycleMailer.welcome user).to be_a_kind_of UserLifecycleMailer
    end

    describe 'the created instance' do
      subject { UserLifecycleMailer.welcome user }

      it 'sets :from_name to "Tip for Tip"' do
        expect(subject.message["from_name"]).to eq "Tip for Tip"
      end

      it 'sets :from_email to "support@tipfortip.com"' do
        expect(subject.message["from_email"]).to eq "support@tipfortip.com"
      end

      it 'sets :subject to the translated value' do
        expect(subject.message["subject"]).to eq I18n.t!('user_lifecycle_mailer.welcome.subject')
      end

      it 'sets the "to" attribute with only one recipient' do
        expect(subject.message['to'].count).to eq 1
      end

      it 'sets the :to attribute to the user\'s name and email' do
        receiver = subject.message["to"][0].with_indifferent_access
        expect(receiver["name"]).to eq user.full_name
        expect(receiver["email"]).to eq user.email
      end
    end
  end
end
