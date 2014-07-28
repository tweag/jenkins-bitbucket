class BitBucketPullRequestStatusFormatter
  attr_accessor :brought_to_you_by_url

  def initialize(brought_to_you_by_url: "http://example.com")
    self.brought_to_you_by_url = brought_to_you_by_url
  end

  def call(job_status)
    [
      *message(job_status),
      "",
      "Brought to you by [Jenkins-Bitbucket](#{brought_to_you_by_url})"
    ].join("\n")
  end

  def message(job_status)
    if job_status
      job_status_message(job_status)
    else
      no_job_status_message(job_status)
    end
  end

  def job_status_message(job_status)
    [
      "# #{job_status.status || job_status.phase} on Jenkins",
      "",
      "[#{job_status.job_name} on Jenkins](#{job_status.url})",
    ]
  end

  def no_job_status_message(job_status)
    [
      "# UNKNOWN on Jenkins",
      "",
      "I don't recall Jenkins ever telling me about a matching job.",
      "",
      "- Perhaps there isn't a job on Jenkins that has started running.",
      "- Perhaps the job doesn't have a number in its name.",
      "- Perhaps this pull request doesn't have a number in its title.",
    ]
  end
end
