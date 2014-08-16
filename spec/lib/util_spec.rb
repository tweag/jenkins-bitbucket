require 'spec_helper'

describe Util do
  describe '#normalize_sha' do
    subject { described_class.normalize_sha(sha) }

    context 'with a small string' do
      let(:sha) { '123' }
      it { is_expected.to eq '123' }
    end

    context 'with a long string' do
      let(:sha) { '1234567890' }
      it { is_expected.to eq '1234567' }
    end

    context 'given nil' do
      let(:sha) { nil }
      it { is_expected.to be nil }
    end
  end
end
