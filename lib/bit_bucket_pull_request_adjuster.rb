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
    prs = client.prs.select do |pr|
      self.class.match(pr.title, job_status.job_name)
    end

    prs.each do |pr|
      adjusted_pr = message_adjuster.call(pr, job_status)
      client.update_pr pr.id, adjusted_pr.fetch(:title), adjusted_pr.fetch(:description)
    end
  end

  def self.match(pr_title, job_name)
    extract_id(pr_title) == extract_id(job_name)
  end

  def self.extract_id(str)
    str.split(/\D/).last
  end
end
