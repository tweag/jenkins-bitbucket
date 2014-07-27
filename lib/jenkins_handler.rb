class JenkinsHandler
  def initialize(jenkins: JenkinsJob, bitbucket:)
    @jenkins   = jenkins
    @bitbucket = bitbucket
  end

  def call(params)
    job_status = JobStatus.new(params)
    @jenkins.upsert_job job_status
    @bitbucket.update_status job_status
  end
end
