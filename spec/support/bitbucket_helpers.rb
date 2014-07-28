module BitBucketHelpers
  def bitbucket
    @bitbucket ||= BitBucketClient.new
  end

  def create_pull_request(title)
    bitbucket.create_pr(title)
  end

  def decline_all_pull_requests
    bitbucket.prs.each do |pr|
      bitbucket.decline_pr pr['id']
    end
  end

  def comments_for(pr)
    bitbucket.comments(pr['id'])
  end

  def all_comments_on_all_prs
    bitbucket.prs.map do |pr|
      bitbucket.comments(pr['id'])
    end.reduce(&:+)
  end

  def reload_pull_request(pr)
    bitbucket.pr(pr['id'])
  end
end

RSpec.configure do |config|
  config.include BitBucketHelpers
end
