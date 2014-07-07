require 'spec_helper'

describe TipCreator do
  let(:user) { FactoryGirl.create :user }
  let(:noun) { FactoryGirl.create :place }

  let(:params) { FactoryGirl.attributes_for(:tip).merge(user: user, noun: noun) }
  subject { TipCreator.new.(params) }

  it 'creates a tip' do
    expect{ subject }.to change{ Tip.count }.by 1
  end

  it 'returns the tip' do
    expect(subject).to be_a_kind_of Tip
  end

  it 'parses string values for the send_at value' do
    params[:send_at] = 'tomorrow'
    expect(subject.send_at.today?).to_not be true
  end

  describe 'parse_send_at' do

    it 'parses a timestamp to that time' do
      time = 1.hour.from_now.change(sec: 0)
      expect(TipCreator.new.send :parse_send_at, time).to eq time
      expect(TipCreator.new.send :parse_send_at, time.to_s).to eq time
      expect(TipCreator.new.send :parse_send_at, time.to_time).to eq time
      expect(TipCreator.new.send :parse_send_at, time.to_datetime).to eq time
    end

    it 'parses "today" as any random time 1 to 4 hours from now' do
      10.times do
        time = TipCreator.new.send :parse_send_at, "today"
        expect(time).to be_between(1.hour.from_now, 4.hours.from_now)
      end
    end

    it 'parses "tomorrow" as any random time tomorrow' do
      10.times do
        time = TipCreator.new.send :parse_send_at, "tomorrow"
        expect(time).to be_between(1.day.from_now.beginning_of_day, 1.day.from_now.end_of_day)
      end
    end

    it 'parses "later this week" as any time in 2 to 4 days' do
      10.times do
        time = TipCreator.new.send :parse_send_at, "later this week"
        expect(time).to be_between(2.days.from_now, 4.days.from_now)
      end
    end

    it 'parses "in a few weeks" as any time in 2 to 4 weeks' do
      10.times do
        time = TipCreator.new.send :parse_send_at, "in a few weeks"
        expect(time).to be_between(2.weeks.from_now, 4.weeks.from_now)
      end
    end

    it 'parses strings case insensitively' do
      expect(TipCreator.new.send :parse_send_at, "TODAY").to be_a_kind_of DateTime
    end

    it 'ignores whitespace around strings' do
      expect(TipCreator.new.send :parse_send_at, " today \n").to be_a_kind_of DateTime
    end

    it 'raises an ArgumentError if no timestamp or parseable string is provided' do
      expect{ TipCreator.new.send :parse_send_at, "SHOULD NOT PARSE"}.to raise_error ArgumentError
    end

  end

end
