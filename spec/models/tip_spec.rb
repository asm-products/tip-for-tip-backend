require 'spec_helper'

describe Tip do
  it { expect(FactoryGirl.build :tip).to be_valid }


  describe 'the `can_purchase_with_reputation` attribute' do
    it 'defaults to false' do
      expect(FactoryGirl.create(:tip, can_purchase_with_reputation: nil).can_purchase_with_reputation).to eq false
    end
  end

  describe 'the `is_anonymous` attribute' do
    it 'defaults to false' do
      expect(FactoryGirl.create(:tip, is_anonymous: nil).is_anonymous).to eq false
    end
  end

  describe 'the `send_at` attribute' do
    it 'defaults to the current time' do
      Timecop.freeze(Time.zone.now) do
        expect(FactoryGirl.create(:tip, send_at: nil).send_at).to eq Time.zone.now
      end
    end
  end

  describe 'the `sent` attribute' do
    it 'defaults to false' do
      expect(FactoryGirl.create(:tip, sent: nil).sent).to eq false
    end
  end

end
