module BitbucketHelpers
  def bitbucket
    @bitbucket ||= BitbucketClient.new
  end

  def create_pull_request(title)
    bitbucket.create_pull_request(title)
  end

  def decline_all_pull_requests
    bitbucket.pull_requests.each do |pull_request|
      bitbucket.decline_pull_request pull_request['id']
    end
  end

  def comments_for(pull_request)
    bitbucket.comments(pull_request['id'])
  end

  def all_comments_on_all_pull_requests
    bitbucket.pull_requests.map do |pull_request|
      bitbucket.comments(pull_request['id'])
    end.reduce(&:+)
  end

  def reload_pull_request(pull_request)
    bitbucket.pull_request(pull_request['id'])
  end

  def update_pull_request_description(pull_request, new_description)
    bitbucket.update_pull_request(pull_request['id'], pull_request['title'], new_description)
  end
end

RSpec.configure do |config|
  config.include BitbucketHelpers
end
