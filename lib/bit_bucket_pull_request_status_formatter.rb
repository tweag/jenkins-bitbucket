class BitBucketPullRequestStatusFormatter
  def call(job_status)
    [
      job_status.job_name,
      job_status.status,
      job_status.phase,
      job_status.url
    ].join("\n")
  end
end
