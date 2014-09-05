describe JobToPullRequestMatcher do
  describe '#normalize_identifier' do
    subject { described_class.normalize_identifier(identifier) }

    context 'given nil' do
      let(:identifier) { nil }
      it { is_expected.to be nil }
    end

    context 'given a string' do
      let(:identifier) { 'a-b/c(123]' }
      it { is_expected.to eq 'abc123' }
    end
  end
end
