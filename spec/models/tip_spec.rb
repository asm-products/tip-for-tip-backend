require 'spec_helper'

describe Tip do
  it { expect(FactoryGirl.build :tip).to be_valid }
  it { should generate_a_uuid }

  it { should validate_presence_of :subject }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_presence_of :noun }
  it { should ensure_inclusion_of(:display_as).in_array Tip::DISPLAY_AS_OPTIONS }

  describe 'the `is_free` attribute' do
    it 'defaults to false' do
      expect(FactoryGirl.create(:tip, is_free: nil).is_free).to eq false
    end
  end

  describe 'the `is_compliment` attribute' do
    it 'defaults to false' do
      expect(FactoryGirl.create(:tip, is_compliment: nil).is_compliment).to eq false
    end
  end

  describe 'the `display_as` attribute' do
    it 'defaults to full_name' do
      expect(FactoryGirl.create(:tip, display_as: nil).display_as).to eq 'full_name'
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
