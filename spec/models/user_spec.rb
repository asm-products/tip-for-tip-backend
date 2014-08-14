require 'spec_helper'

describe User do

  it { expect(FactoryGirl.create :user).to be_valid }
  it { should generate_a_uuid }
  it { should validate_presence_of :email }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :username }

  context 'after creation' do
    subject { FactoryGirl.create :user }
    it 'creates a CustomerAccount record for the user' do
      expect{ subject }.to change(CustomerAccount, :count).by 1
      expect( subject.customer_account ).to_not be_nil
    end
  end
end
