class PullRequestAdjuster
  attr_accessor :repo, :message_adjuster, :job_store

  def initialize(
    repo,
    message_adjuster: PullRequestMessageAdjuster.new,
    job_store:        JenkinsJob
  )
    self.repo             = repo
    self.message_adjuster = message_adjuster
    self.job_store        = job_store
  end

  def update_status(job)
    pull_requests = repo.pull_requests.select do |pull_request|
      pull_request.identifier == job.identifier
    end

    pull_requests.each do |pull_request|
      update_pull_request_with_job_status pull_request, job
    end
  end

  def update_status_from_pull_request(pull_request)
    job = job_store[pull_request.identifier]
    update_pull_request_with_job_status pull_request, job
  end

  def update_status_from_pull_request_id(id)
    update_status_from_pull_request repo.pull_request(id)
  end

  def update_statuses_for_all_pull_requests
    repo.pull_requests.each do |pull_request|
      update_status_from_pull_request pull_request
    end
  end

  def set_automerge_for_pull_request(id, on_or_off)
    pull_request = repo.pull_request(id)
    pull_request.embedded_data['automerge?'] = on_or_off
    update_status_from_pull_request pull_request
  end

  def update_pull_request_with_job_status(pull_request, job)
    commits = repo.commits(pull_request)
    status_message = StatusMessage.new(pull_request, job, commits)
    adjusted_pull_request = message_adjuster.call(status_message)

    repo.update_pull_request \
      pull_request.id,
      adjusted_pull_request.fetch(:title),
      adjusted_pull_request.fetch(:description)
  end
  private :update_pull_request_with_job_status
end
