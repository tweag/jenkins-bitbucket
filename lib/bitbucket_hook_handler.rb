class BitbucketHookHandler
  def initialize(jenkins: JenkinsJob, bitbucket:)
    @jenkins   = jenkins
    @bitbucket = bitbucket
  end

  def call(params)
    pull_request_params = params["pullrequest_created"] or return
    pull_request = BitBucketClient::PullRequest.new(pull_request_params)
    job = nil
    @bitbucket.update_status_from_pull_request job, pull_request
  end
end
