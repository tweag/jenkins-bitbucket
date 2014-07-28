require 'bit_bucket_pull_request_message_adjuster'

class BitBucketPullRequestAdjuster
  attr_accessor :client, :message_adjuster

  def initialize(
    client,
    message_adjuster: BitBucketPullRequestMessageAdjuster.new
  )
    self.client           = client
    self.message_adjuster = message_adjuster
  end

  def update_status(job_status)
    client.prs
      .select { |pr| self.class.match(pr.title, job_status.job_name) }
      .each   { |pr| update_status_from_pull_request(job_status, pr) }
  end

  def update_status_from_pull_request(job_status, pr)
    adjusted_pr = message_adjuster.call(pr, job_status)
    client.update_pr pr.id, adjusted_pr.fetch(:title), adjusted_pr.fetch(:description)
  end

  def self.match(pr_title, job_name)
    extract_id(pr_title) == extract_id(job_name)
  end

  def self.extract_id(str)
    str.split(/\D/).last
  end
end
