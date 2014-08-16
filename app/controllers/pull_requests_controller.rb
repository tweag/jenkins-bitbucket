class PullRequestsController < ApplicationController
  def index
    @pull_requests = bitbucket_client.pull_requests.map do |pull_request|
      [pull_request, JenkinsJob[pull_request.identifier]]
    end
  end
end
