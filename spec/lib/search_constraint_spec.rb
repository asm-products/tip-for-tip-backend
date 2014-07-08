require 'spec_helper'

describe SearchConstraint do
  describe "#matches?" do
    let(:request) { Object.new }
    subject { SearchConstraint.matches? request }

    it 'returns true when the q query param is present' do
      allow(request).to receive(:query_parameters).and_return({ q: ''})
      expect(subject).to eq true
      allow(request).to receive(:query_parameters).and_return({ q: 'lorem'})
      expect(subject).to eq true
      allow(request).to receive(:query_parameters).and_return({ q: nil})
      expect(subject).to eq true
    end

    it 'returns false when the q query is not present' do
      allow(request).to receive(:query_parameters).and_return({})
      expect(subject).to eq false
    end
  end
end
