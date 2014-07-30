class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  extend Memoist

  private

  memoize \
  def job_status_interactor
    JobStatusInteractor.new(bitbucket: bitbucket_pull_request_adjuster)
  end

  memoize \
  def pull_request_interactor
    PullRequestInteractor.new(bitbucket: bitbucket_pull_request_adjuster)
  end

  memoize \
  def bitbucket_pull_request_adjuster
    PullRequestAdjuster.new(
      bitbucket_client,
      message_adjuster: message_adjuster
    )
  end

  memoize \
  def message_adjuster
    PullRequestMessageAdjuster.new(
      renderer: status_message_renderer
    )
  end

  memoize \
  def status_message_renderer
    StatusMessageRenderer.new(self)
  end

  memoize \
  def bitbucket_client
    BitbucketClient.new
  end
end
