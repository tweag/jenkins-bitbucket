require 'bit_bucket_pull_request_status_formatter'

describe BitBucketPullRequestStatusFormatter do
  let(:formatter) { described_class.new }

  describe "#call" do
    subject { formatter.call(job_status) }

    let(:job_status) do
      double(
        job_name: "my-job",
        status:   "the-status",
        phase:    "the-phase",
        url:      "http://example.com"
      )
    end

    it { should include job_status.job_name }
    it { should include job_status.phase }
    it { should include job_status.status }
    it { should include job_status.url }
  end
end
