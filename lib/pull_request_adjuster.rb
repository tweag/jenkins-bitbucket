class PullRequestAdjuster
  attr_accessor :repo, :message_adjuster, :job_store

  def initialize(
    repo,
    message_adjuster: PullRequestMessageAdjuster.new,
    job_store:        JenkinsJob
  )
    self.repo             = repo
    self.job_store        = job_store
    self.message_adjuster = message_adjuster
  end

  def update_status(job)
    pull_requests = repo.pull_requests.select do |pull_request|
      self.class.match(pull_request.identifier, job.identifier)
    end

    pull_requests.each do |pull_request|
      update_pull_request_with_job_status(pull_request, job)
    end
  end

  def update_status_from_pull_request(pull_request)
    job = job_store[pull_request.identifier]
    update_pull_request_with_job_status(pull_request, job)
  end

  def update_status_from_pull_request_id(id)
    update_status_from_pull_request repo.pull_request(id)
  end

  def update_statuses_for_all_pull_requests
    repo.pull_requests.each do |pull_request|
      update_status_from_pull_request pull_request
    end
  end

  def update_pull_request_with_job_status(pull_request, job)
    adjusted_pull_request = message_adjuster.call(pull_request, job)
    repo.update_pull_request \
      pull_request.id,
      adjusted_pull_request.fetch(:title),
      adjusted_pull_request.fetch(:description)
  end
  private :update_pull_request_with_job_status

  def self.match(pull_request_title, identifier)
    pull_request_title && pull_request_title == identifier
  end
end
