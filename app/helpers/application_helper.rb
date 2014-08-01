module ApplicationHelper
  def repo_url(extra_path = '')
    "https://bitbucket.org/#{ENV.fetch('BIT_BUCKET_REPO')}#{extra_path}"
  end

  def user_url
    "https://bitbucket.org/#{ENV.fetch('BIT_BUCKET_USER')}"
  end
end
