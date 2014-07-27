class BitBucketPullRequestStatusFormatter
  attr_accessor :brought_to_you_by_url

  def initialize(brought_to_you_by_url: "http://example.com")
    self.brought_to_you_by_url = brought_to_you_by_url
  end

  def call(job_status)
    [
      "# #{job_status.status} #{job_status.phase} on Jenkins",
      "",
      "[#{job_status.job_name} on Jenkins](#{job_status.url})",
      "",
      "Brought to you by [Jenkins-Bitbucket](#{brought_to_you_by_url})"
    ].join("\n")
  end
end
