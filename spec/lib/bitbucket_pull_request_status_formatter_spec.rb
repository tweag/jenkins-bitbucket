require 'bitbucket_pull_request_status_formatter'

describe BitbucketPullRequestStatusFormatter do
  let(:formatter) { described_class.new(root_url: 'http://jbb.com') }

  describe '#call' do
    subject { formatter.call(pull_request, job) }

    let(:job) do
      JenkinsJobExample.build(
        'name' => 'my-job',
        'build' => {
          'status' => 'the-status',
          'full_url' => 'http://example.com'
        }
      )
    end

    let(:pull_request) do
      double(id: 123)
    end

    it { should include job.job_name }
    it { should include job.status }
    it { should include job.url }
    it { should include '(http://jbb.com/bitbucket/refresh/123)' }
    it { should include '(http://jbb.com)' }

    context 'when there is no job' do
      let(:job) {}
      it { should include 'UNKNOWN' }
    end
  end
end