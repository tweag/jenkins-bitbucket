require 'spec_helper'

describe PullRequestAdjuster, '.match' do
  it { expect(described_class.match(123, 123)).to be_truthy }
  it { expect(described_class.match(123, nil)).to be_falsey }
  it { expect(described_class.match(nil, nil)).to be_falsey }
end
