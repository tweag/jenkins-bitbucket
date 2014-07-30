class PullRequestAdjuster
  attr_accessor :repo, :message_adjuster, :jenkins_jobs

  def initialize(
    repo,
    message_adjuster: BitbucketPullRequestMessageAdjuster.new,
    jenkins_jobs:     JenkinsJob
  )
    self.repo             = repo
    self.jenkins_jobs     = jenkins_jobs
    self.message_adjuster = message_adjuster
  end

  def update_status(job)
    pull_requests = repo.pull_requests.select do |pull_request|
      self.class.match(pull_request.story_number, job.number)
    end

    pull_requests.each do |pull_request|
      update_pull_request_with_job_status(pull_request, job)
    end
  end

  def update_status_from_pull_request(pull_request)
    job = if pull_request.story_number
            jenkins_jobs.fetch(pull_request.story_number)
          end

    update_pull_request_with_job_status(pull_request, job)
  end

  def update_status_from_pull_request_id(id)
    update_status_from_pull_request repo.pull_request(id)
  end

  def update_pull_request_with_job_status(pull_request, job)
    adjusted_pull_request = message_adjuster.call(pull_request, job)
    repo.update_pull_request \
      pull_request.id,
      adjusted_pull_request.fetch(:title),
      adjusted_pull_request.fetch(:description)
  end
  private :update_pull_request_with_job_status

  def self.match(pull_request_title, job_number)
    pull_request_title && pull_request_title == job_number
  end
end
