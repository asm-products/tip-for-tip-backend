require 'spec_helper'

describe User do

  it { expect(FactoryGirl.create :user).to be_valid }
  it { should generate_a_uuid }
  it { should validate_presence_of :email }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :username }

end
