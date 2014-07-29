class TestsController < ApplicationController
  def show
    @pull_requests = bitbucket_client.pull_requests
  end
end
