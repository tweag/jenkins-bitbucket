require 'bitbucket_pull_request_message_adjuster'
require 'util'

class BitbucketPullRequestAdjuster
  attr_accessor :client, :message_adjuster, :jenkins_jobs

  def initialize(
    client,
    message_adjuster: BitbucketPullRequestMessageAdjuster.new,
    jenkins_jobs:     JenkinsJob
  )
    self.client           = client
    self.jenkins_jobs     = jenkins_jobs
    self.message_adjuster = message_adjuster
  end

  def update_status(job)
    client.prs
      .select { |pr| self.class.match(Util.extract_id(pr.title), job.number) }
      .each   { |pr| update_pr_with_job_status(pr, job) }
  end

  def update_status_from_pull_request(pr)
    job_number = Util.extract_id(pr.title)
    job = jenkins_jobs.fetch(Integer(job_number)) if job_number
    update_pr_with_job_status(pr, job)
  end

  def update_status_from_pull_request_id(id)
    update_status_from_pull_request client.pr(id)
  end

  private \
  def update_pr_with_job_status(pr, job)
    adjusted_pr = message_adjuster.call(pr, job)
    client.update_pr pr.id, adjusted_pr.fetch(:title), adjusted_pr.fetch(:description)
  end

  def self.match(pr_title, job_number)
    pr_title and pr_title == job_number
  end
end
