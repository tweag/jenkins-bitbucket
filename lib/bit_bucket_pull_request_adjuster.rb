require 'bit_bucket_pull_request_message_adjuster'
require 'util'

class BitBucketPullRequestAdjuster
  attr_accessor :client, :message_adjuster, :jenkins_jobs

  def initialize(
    client,
    message_adjuster: BitBucketPullRequestMessageAdjuster.new,
    jenkins_jobs:     JenkinsJob
  )
    self.client           = client
    self.jenkins_jobs     = jenkins_jobs
    self.message_adjuster = message_adjuster
  end

  def update_status(job_status)
    client.prs
      .select { |pr| self.class.match(Util.extract_id(pr.title), job_status.job_number) }
      .each   { |pr| update_pr_with_job_status(pr, job_status) }
  end

  def update_status_from_pull_request(pr)
    job_number = Util.extract_id(pr.title) or return
    job_status = jenkins_jobs.get_job_status(Integer(job_number))
    update_pr_with_job_status(pr, job_status)
  end

  private \
  def update_pr_with_job_status(pr, job_status)
    adjusted_pr = message_adjuster.call(pr, job_status)
    client.update_pr pr.id, adjusted_pr.fetch(:title), adjusted_pr.fetch(:description)
  end

  def self.match(pr_title, job_number)
    pr_title == job_number
  end
end
