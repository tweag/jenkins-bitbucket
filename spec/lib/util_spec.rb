require 'spec_helper'

describe Util do
  describe '.extract_id' do
    context 'when it contains a number' do
      it 'extracts the number' do
        [
          'something-another-234',
          'something234',
          '234',
          'something234another',
          'something098098-234',
          '234something',
          '234 something',
          'something 234'
        ].each do |str|
          expect(described_class.extract_id(str)).to eq 234
        end
      end
    end

    context "when it doesn't contain a number" do
      it 'extracts the number' do
        [
          'something-another',
          'something',
          '',
          'something another',
          ' something-'
        ].each do |str|
          expect(described_class.extract_id(str)).to be nil
        end
      end
    end
  end
end
