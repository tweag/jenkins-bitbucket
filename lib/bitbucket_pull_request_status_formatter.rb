class BitbucketPullRequestStatusFormatter
  attr_accessor :root_url

  def initialize(root_url: 'http://example.com')
    self.root_url = root_url
  end

  def call(pull_request, job)
    [
      *message(pull_request, job),
      '',
      "Brought to you by [Jenkins-Bitbucket](#{root_url})"
    ].join("\n")
  end

  def message(pull_request, job)
    if job
      job_status_message(pull_request, job)
    else
      no_job_status_message(pull_request)
    end
  end

  def job_status_message(pull_request, job)
    [
      "# #{job.status || job.phase} on Jenkins",
      refresh_link(pull_request),
      '',
      "[#{job.job_name} on Jenkins](#{job.url})"
    ]
  end

  # rubocop:disable Style/MethodLength
  def no_job_status_message(pull_request)
    [
      '# UNKNOWN on Jenkins',
      '',
      "I don't recall Jenkins ever telling me about a matching job.",
      '',
      "- Perhaps there isn't a job on Jenkins that has started running.",
      "- Perhaps the job doesn't have a number in its name.",
      "- Perhaps this pull request doesn't have a number in its title.",
      '',
      "Once you fix the problem, you can #{refresh_link(pull_request)}"
    ]
  end
  # rubocop:enable Style/MethodLength

  def refresh_link(pull_request)
    "[refresh this message](#{root_url}/bitbucket/refresh/#{pull_request.id})"
  end
end
