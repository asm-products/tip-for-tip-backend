require 'spec_helper'

describe 'Worker exception handling' do

  describe 'any worker' do
    let(:error) { Exception.new('foo') }

    class DummyWorker
      include Sidekiq::Worker
      def perform; end
    end

    subject { Sidekiq::Testing.inline! { DummyWorker.perform_async } }

    # it 'notifies rollbar when an exception occurs while performing' do
    #   expect(Rollbar).to receive(:report_exception).with error
    #   allow_any_instance_of(DummyWorker).to receive(:perform) { raise error }
    #   expect{ subject }.to raise_error error
    # end

    # Note that error handlers are only relevant to the Sidekiq server process.
    # They aren't active in Rails console, for instance.
    # BOOOOOO

  end

end
