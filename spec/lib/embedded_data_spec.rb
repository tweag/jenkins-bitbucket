describe EmbeddedData do
  describe '.load' do
    subject { described_class.load(text) }

    context 'no embedded data' do
      let(:text) { 'No [data]: here' }
      it { is_expected.to eq({}) }
    end

    context 'embedded data' do
      let(:text) do
        %(

[data]: {"the":%20"info"})
      end
      it { is_expected.to eq 'the' => 'info' }
    end
  end

  describe '.dump' do
    subject { described_class.dump(data) }

    let(:data) { { 'the' => 'info here' } }
    it { is_expected.to eq '[data]: {"the":"info%20here"}'  }
  end
end
