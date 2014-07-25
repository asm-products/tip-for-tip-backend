require 'spec_helper'

describe UserLifecycleMailer do
  include Support::Mandrill

  describe '#send' do
    let(:user) { FactoryGirl.create(:user) }
    let(:instance) do
      UserLifecycleMailer.new user, 'foo',
        [{"content"=>"example content", "name"=>"example name"}],
        # { to: [{ email: user.email, name: user.full_name, type: :to }] }
        {
          "from_name"=>"Example Name"
        }
      end
    before { stub_mandrill }

    it 'sends the message to mandrill' do
      instance.send!
    end

    context 'when mandrill returns an error' do

      it 'rescues Mandrill::Error and reports it to Rollbar' do
        expect(Rollbar).to receive(:report_exception).with Mandrill::Error
        instance.send!
      end

    end
  end

end
