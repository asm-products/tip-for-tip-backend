require 'spec_helper'

describe Withdrawal do
  subject{ FactoryGirl.build :withdrawal }
  before { Accounts::seed }

  it('has a valid factory') { expect(subject).to be_valid }
  it { should validate_presence_of :user }
  it { should validate_presence_of :transaction_id }
end
