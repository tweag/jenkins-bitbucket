require 'spec_helper'

describe PullRequest, type: :model do
  subject { described_class.new(PullRequestExample.attributes(attrs)) }

  let(:attrs) do
    {
      'source' => { 'commit' => { 'hash' => 'ccccccc' } },
      'links' => { 'self' => { 'href' => 'http://pullrequest.com' } }
    }
  end

  describe '#sha' do
    subject { super().sha }
    it { is_expected.to eq 'ccccccc' }
  end

  describe '#url' do
    subject { super().url }
    it { is_expected.to eq 'http://pullrequest.com' }
  end
end
