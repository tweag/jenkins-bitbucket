require 'jenkins_handler'
require 'bit_bucket_client'
require 'bit_bucket_pull_request_adjuster'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  extend Memoist

  private

  memoize \
  def jenkins_handler
    JenkinsHandler.new(
      bitbucket: BitBucketPullRequestAdjuster.new(
        bit_bucket_client,
        message_adjuster: BitBucketPullRequestMessageAdjuster.new(
          formatter: BitBucketPullRequestStatusFormatter.new(
            brought_to_you_by_url: root_url
          )
        )
      )
    )
  end

  memoize \
  def bit_bucket_client
    BitBucketClient.new
  end
end
