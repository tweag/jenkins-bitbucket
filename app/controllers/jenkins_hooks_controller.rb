require 'jenkins_handler'
require 'bit_bucket_client'
require 'bit_bucket_pull_request_adjuster'

class JenkinsHooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    jenkins_handler.call params
    render text: "Thanks"
  end

  private

  def jenkins_handler
    @_handler ||= JenkinsHandler.new(
      bitbucket: BitBucketPullRequestAdjuster.new(
        BitBucketClient.new,
        message_adjuster: BitBucketPullRequestMessageAdjuster.new(
          formatter: BitBucketPullRequestStatusFormatter.new(
            brought_to_you_by_url: root_url
          )
        )
      )
    )
  end
end

