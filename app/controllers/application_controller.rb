require 'jenkins_handler'
require 'bitbucket_hook_handler'
require 'bitbucket_pull_request_adjuster'
require 'message_formatter'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  extend Memoist

  private

  memoize \
  def jenkins_handler
    JenkinsHandler.new(bitbucket: bitbucket_pull_request_adjuster)
  end

  memoize \
  def bitbucket_pull_request_adjuster
    BitbucketPullRequestAdjuster.new(
      bitbucket_client,
      message_adjuster: message_adjuster
    )
  end

  memoize \
  def message_adjuster
    BitbucketPullRequestMessageAdjuster.new(
      formatter: status_message_formatter
    )
  end

  memoize \
  def status_message_formatter
    MessageFormatter.new(self)
  end

  memoize \
  def bitbucket_hook_handler
    BitbucketHookHandler.new(bitbucket: bitbucket_pull_request_adjuster)
  end

  memoize \
  def bitbucket_client
    BitbucketClient.new
  end
end
