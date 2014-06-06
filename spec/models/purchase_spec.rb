require 'spec_helper.rb'

describe Purchase do
  let(:verified_purchase) { FactoryGirl.build :purchase, :verified }

  it { should validate_presence_of :user }
  it { should validate_presence_of :tip }
  it { should validate_presence_of :service }
  it { expect(verified_purchase).to validate_presence_of :receipt_data }
  it { should validate_presence_of :encoded_receipt_data }
  it { should validate_presence_of :transaction_id }
  it { should ensure_inclusion_of(:service).in_array(Purchase::SERVICES) }

  context 'when verified' do
    subject { FactoryGirl.create :purchase, verified: true }
    it 'should validate uniquess of transaction id' do
      first = FactoryGirl.create :purchase, :verified
      second = FactoryGirl.build :purchase, :verified, transaction_id: first.transaction_id
      # invalid when there's a verified purchase with the same transaction id.
      expect(second).to_not be_valid
      first.update_attributes! verified: false
      # valid when there's an unverified purchase with the same transaction id.
      expect(second).to be_valid
    end
  end

end
