require 'spec_helper'

describe Perk do

  it { expect(FactoryGirl.build :perk).to be_valid }
  it { should generate_a_uuid }
  it { should validate_presence_of :title }
  it { should validate_presence_of :subscription }

end
