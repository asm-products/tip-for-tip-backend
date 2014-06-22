require 'spec_helper'

describe Subscription do

  it { expect(FactoryGirl.build :subscription).to be_valid }
  it { should validate_presence_of :noun }
  it { should validate_presence_of :partner }

end
