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
    @jenkins_handler ||= JenkinsHandler.new(bitbucket: bit_bucket_manipulator)
  end

  def bit_bucket_manipulator
    @bitbucket_manipulator ||= BitBucketPullRequestAdjuster.new(bit_bucket_client)
  end

  def bit_bucket_client
    @bitbucket ||= BitBucketClient.new
  end
end

