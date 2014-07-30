class JobStatusInteractor
  def initialize(jenkins: JenkinsJob, bitbucket:)
    @jenkins   = jenkins
    @bitbucket = bitbucket
  end

  def call(params)
    job = @jenkins.new_from_jenkins(params)
    @bitbucket.update_status job if @jenkins.store(job)
  end
end
