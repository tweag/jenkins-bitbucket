class BitBucketPullRequestAdjuster
  attr_accessor :client, :status_renderer

  def initialize(client)
    self.client          = client
    self.status_renderer = self.class.method(:job_status_markdown)
  end

  def update_status(job_status)
    prs = client.prs.select do |pr|
      self.class.match(pr.title, job_status.job_name)
    end

    prs.each do |pr|
      new_description = pr.description + "\n" + status_renderer.call(job_status)
      client.update_pr pr.id, pr.title, new_description
    end
  end

  def self.match(pr_title, job_name)
    extract_id(pr_title) == extract_id(job_name)
  end

  def self.job_status_markdown(job_status)
    [
      "* * * * * * * * * * * * * * *",
      job_status.job_name,
      job_status.status,
      job_status.phase,
      job_status.url
    ].join("\n")
  end

  def self.extract_id(str)
    str.split(/\D/).last
  end
end
