require 'spec_helper'

describe PullRequest, type: :model do
  subject { described_class.new(PullRequestExample.attributes(attrs)) }

  let(:attrs) do
    {
      'source' => { 'commit' => { 'hash' => 'ccccccc' } }
    }
  end

  describe '#sha' do
    subject { super().sha }
    it { is_expected.to eq 'ccccccc' }
  end
end
