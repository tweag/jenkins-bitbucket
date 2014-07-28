module ApplicationHelper
  def repo_url
    "https://bitbucket.org/#{ENV.fetch('BIT_BUCKET_REPO')}"
  end

  def user_url
    "https://bitbucket.org/#{ENV.fetch('BIT_BUCKET_USER')}"
  end
end
