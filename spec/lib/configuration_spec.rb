# require 'spec_helper'

describe Configuration do
  subject(:configuration) { described_class.new }

  its(:image_required) { should be_falsey }
  its(:story_number_example) { should eq('123') }
  its(:story_number_regexp) { should eq('\d+') }

  context 'with options set' do
    before do
      configuration.image_required = true
    end

    its(:image_required) { should be_truthy }
  end

  describe '#story_number_checker' do
    it 'compiles a regex from story_number_regexp' do
      expect(configuration.story_number_checker).to match('123')
    end
  end

  describe '.from_env' do
    subject { described_class.from_env(env) }

    let(:env) { {} }

    its(:image_required) { should be_falsey }
    its(:story_number_example) { should eq('123') }
    its(:story_number_regexp) { should eq('\d+') }

    context 'with env vars' do
      let(:env) do
        {
          'IMAGE_REQUIRED' => 'true',
          'STORY_NUMBER_REGEXP' => '\d-\d-\d',
          'STORY_NUMBER_EXAMPLE' => '1-2-3'
        }
      end

      its(:image_required) { should eq(true) }
      its(:story_number_example) { should eq('1-2-3') }
      its(:story_number_regexp) { should eq('\d-\d-\d') }
    end
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
