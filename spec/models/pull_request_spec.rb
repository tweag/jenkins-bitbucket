require 'spec_helper'

describe PullRequest do
  subject { described_class.new(PullRequestExample.attributes(attrs)) }

  let(:attrs) do
    {
      'source' => { 'commit' => { 'hash' => 'ccccccc' } }
    }
  end

  its(:sha) { should eq 'ccccccc' }
end
