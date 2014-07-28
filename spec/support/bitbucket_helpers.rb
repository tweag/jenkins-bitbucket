module BitbucketHelpers
  def bitbucket
    @bitbucket ||= BitbucketClient.new
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

  def update_pull_request_description(pr, new_description)
    bitbucket.update_pr(pr['id'], pr['title'], new_description)
  end
end

RSpec.configure do |config|
  config.include BitbucketHelpers
end
