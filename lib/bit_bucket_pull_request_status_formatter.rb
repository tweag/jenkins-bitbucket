class BitBucketPullRequestStatusFormatter
  attr_accessor :root_url

  def initialize(root_url: "http://example.com")
    self.root_url = root_url
  end

  def call(pull_request, job_status)
    [
      *message(pull_request, job_status),
      "",
      "Brought to you by [Jenkins-Bitbucket](#{root_url})"
    ].join("\n")
  end

  def message(pull_request, job_status)
    if job_status
      job_status_message(pull_request, job_status)
    else
      no_job_status_message(pull_request, job_status)
    end
  end

  def job_status_message(pull_request, job_status)
    [
      "# #{job_status.status || job_status.phase} on Jenkins",
      refresh_link(pull_request),
      "",
      "[#{job_status.job_name} on Jenkins](#{job_status.url})",
    ]
  end

  def no_job_status_message(pull_request, job_status)
    [
      "# UNKNOWN on Jenkins",
      "",
      "I don't recall Jenkins ever telling me about a matching job.",
      "",
      "- Perhaps there isn't a job on Jenkins that has started running.",
      "- Perhaps the job doesn't have a number in its name.",
      "- Perhaps this pull request doesn't have a number in its title.",
      "",
      "Once you fix the problem, you can #{refresh_link(pull_request)}"
    ]
  end

  def refresh_link(pull_request)
    "[refresh this message](#{root_url}/bitbucket/refresh/#{pull_request.id})"
  end
end
