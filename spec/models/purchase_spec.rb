require 'spec_helper.rb'

describe Purchase do
  subject{ FactoryGirl.build :purchase }

  it('has a valid factory') { expect(subject).to be_valid }
  it { should validate_presence_of :user }
  it { should validate_presence_of :tip }
  it { should validate_presence_of :transaction_id }
  it { should validate_presence_of :service }
  it { should ensure_inclusion_of(:service).in_array(Purchase::SERVICES) }
  it "should validate uniqueness of transaction_id scoped to service" do
    subject.save!
    other = FactoryGirl.build :purchase, transaction_id: subject.transaction_id
    expect(other).to be_invalid
    other.service = :google
    expect(other).to be_valid
  end
  it { should validate_presence_of :iap_receipt_verification }

  context 'if the associated iap_receipt_verification is unsuccessful' do
    let(:verification) { FactoryGirl.create(:iap_receipt_verification, :unsuccessful) }
    subject { FactoryGirl.build :purchase, iap_receipt_verification: verification }
    it { should be_invalid }
  end

end
