class JenkinsHandler
  def initialize(jenkins: JenkinsJob, bitbucket:)
    @jenkins   = jenkins
    @bitbucket = bitbucket
  end

  def call(params)
    job_status = JenkinsJob.new_from_jenkins(params)
    @jenkins.save_job_status job_status
    @bitbucket.update_status job_status
  end
end
