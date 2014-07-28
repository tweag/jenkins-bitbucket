require 'spec_helper'
require 'bit_bucket_pull_request_message_adjuster'

describe BitBucketPullRequestMessageAdjuster do
  let(:message_adjuster) do
    described_class.new(
      separator: "xxx",
      formatter: proc { |job| job.job_name }
    )
  end

  describe "#call" do
    subject do
      message_adjuster.call(pull_request, job_status)
    end

    let(:job_status) { JobStatus.new('name' => 'THE-JOB-NAME') }

    let(:pull_request) do
      double(title: "original title", description: original_description)
    end

    context "when a status is not already in the message" do
      let(:original_description) { "my pr" }

      its([:title])       { should eq "original title" }
      its([:description]) { should eq "my pr\nxxx\nTHE-JOB-NAME" }
    end

    context "when a status is already in the message" do
      let(:original_description) { "my pr\nxxx\nOLD STATUS" }

      its([:title])       { should eq "original title" }
      its([:description]) { should eq "my pr\nxxx\nTHE-JOB-NAME" }
    end

    context "when there is no job status" do
      let(:job_status) {}
    end
  end
end
