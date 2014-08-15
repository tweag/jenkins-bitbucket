require 'spec_helper'

describe JenkinsJob, type: :model do
  subject { described_class.new_from_jenkins(params) }

  let(:params) do
    {
      'name'  => 'the-name-123',
      'url'   => 'job/test-job-for-webhooks/',
      'build' =>
      {
        'full_url' => 'http://example.com/the-full-url',
        'number'   => 3,
        'phase'    => 'the-phase',
        'status'   => 'the-status',
        'url'      => 'job/test-job-for-webhooks/3/',
        'scm'      =>
        {
          'url'    => 'git@bitbucket.org:mountdiablo/ce_bacchus.git',
          'branch' => 'origin/my-branch/STORY-123',
          'commit' => '9a6e22c90bb0c90781dcf6f4ff94b52f97d80883'
        },
        'artifacts'  => {}
      }
    }
  end

  describe '#name' do
    subject { super().name }
    it { is_expected.to eq 'the-name-123' }
  end

  describe '#identifier' do
    subject { super().identifier }
    it { is_expected.to eq 'my-branch/STORY-123' }
  end

  describe '#phase' do
    subject { super().phase }
    it { is_expected.to eq 'the-phase' }
  end

  describe '#status' do
    subject { super().status }
    it { is_expected.to eq 'the-status' }
  end

  describe '#url' do
    subject { super().url }
    it { is_expected.to eq 'http://example.com/the-full-url' }
  end

  describe '#as_json' do
    subject { super().as_json }
    it { is_expected.to eq params }
  end

  describe '#sha' do
    subject { super().sha }
    it { is_expected.to eq '9a6e22c90bb0c90781dcf6f4ff94b52f97d80883' }
  end

  context 'when it has no status' do
    let(:params) do
      JenkinsJobExample.attributes.tap do |attrs|
        attrs['build'].delete('status')
      end
    end

    describe '#status' do
      subject { super().status }
      it { is_expected.to be nil }
    end
  end
end
