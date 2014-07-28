require 'bit_bucket_pull_request_status_formatter'

describe BitBucketPullRequestStatusFormatter do
  let(:formatter) { described_class.new }

  describe "#call" do
    subject { formatter.call(job_status) }

    let(:job_status) do
      double(
        job_name: "my-job",
        status:   "the-status",
        url:      "http://example.com"
      )
    end

    it { should include job_status.job_name }
    it { should include job_status.status }
    it { should include job_status.url }

    context "when there is no job" do
      let(:job_status) {}
      it { should include 'UNKNOWN' }
    end
  end
end
