require 'spec_helper.rb'

describe ItunesPurchaseCreator do
  include Support::ItunesReceipts::VerificationMock
  before{ stub_successful_itunes_receipt_verification }

  let(:user) { FactoryGirl.create :user }
  let(:tip)  { FactoryGirl.create :tip  }
  subject{ ItunesPurchaseCreator.new.(user, tip, "1", "encoded receipt") }

  it 'creates a purchase instance' do
    expect{ subject }.to change{ Purchase.count }.by 1
  end

  it 'needs more specs' do
    # pending
    # TODO
  end

end
