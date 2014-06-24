require 'spec_helper.rb'

describe IapReceiptVerification do
  subject { FactoryGirl.build :iap_receipt_verification, :successful }

  it('has a valid factory') { expect(FactoryGirl.build(:iap_receipt_verification)).to be_valid }
  it('has a valid unsuccessful factory') { expect(FactoryGirl.build :iap_receipt_verification, :unsuccessful).to be_valid }

  it { should validate_presence_of :user }
  it { should validate_presence_of :service }
  it { should ensure_inclusion_of(:service).in_array Purchase::SERVICES }

  context 'when successful' do
    it { validate_presence_of :receipt_data }
  end
  context 'when unsuccessful' do
    subject { FactoryGirl.build :iap_receipt_verification, :unsuccessful }
    it { validate_presence_of :result }
    it { validate_presence_of :result_message }
  end

end
