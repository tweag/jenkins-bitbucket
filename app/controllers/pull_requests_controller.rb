class PullRequestsController < ApplicationController
  def index
    require 'pry'; binding.pry
    @pull_requests = bitbucket_client.pull_requests.map do |pull_request|
      [pull_request, JenkinsJob[pull_request.identifier]]
    end
  end
end
