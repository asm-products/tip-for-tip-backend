require 'spec_helper'

describe NounCreator do

  it { should validate_presence_of :noun }
  it { should validate_presence_of :user }

end
