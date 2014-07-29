require 'spec_helper'
require 'bitbucket_pull_request_message_adjuster'

describe BitbucketPullRequestMessageAdjuster do
  let(:message_adjuster) do
    described_class.new(
      separator: 'xxx',
      formatter: proc { |_pull_request, job| job.job_name }
    )
  end

  describe '#call' do
    subject do
      message_adjuster.call(pull_request, job)
    end

    let(:job) { build_job('name' => 'THE-JOB-NAME') }

    let(:pull_request) do
      double(title: 'original title', description: original_description)
    end

    context 'when a status is not already in the message' do
      let(:original_description) { 'my pull request' }

      its([:title])       { should eq 'original title' }
      its([:description]) { should eq "my pull request\nxxx\nTHE-JOB-NAME" }
    end

    context 'when a status is already in the message' do
      let(:original_description) { "my pull request\nxxx\nOLD STATUS" }

      its([:title])       { should eq 'original title' }
      its([:description]) { should eq "my pull request\nxxx\nTHE-JOB-NAME" }
    end

    context 'when there is no job' do
      let(:job) {}
    end
  end
end
