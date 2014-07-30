class JenkinsHandler
  def initialize(jenkins: JenkinsJob, bitbucket:)
    @jenkins   = jenkins
    @bitbucket = bitbucket
  end

  def call(params)
    job = @jenkins.new_from_jenkins(params)

    @jenkins.store job
    @bitbucket.update_status job
  end
end
