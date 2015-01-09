# require 'spec_helper'

describe Configuration do
  subject(:configuration) { described_class.new }

  its(:image_required) { should be_falsey }

  context 'with options set' do
    before do
      configuration.image_required = true
    end

    its(:image_required) { should be_truthy }
  end

  describe '.instance' do
    it 'returns the same instance' do
      expect(described_class.instance).to eq(described_class.instance)
    end
  end

  describe '.reset!' do
    it 'resets the instance' do
      before_reset = described_class.instance
      described_class.reset!
      expect(described_class.instance).to_not eq(before_reset)
    end
  end
end
