require 'spec_helper'

describe PullRequestAdjuster, '.match' do
  it { expect(described_class.match(123, 123)).to be_true }
  it { expect(described_class.match(123, nil)).to be_false }
  it { expect(described_class.match(nil, nil)).to be_false }
end
