require 'spec_helper'

describe Partner do

  it { expect(FactoryGirl.build :partner).to be_valid }

  it { should validate_presence_of :primary_user }

end
