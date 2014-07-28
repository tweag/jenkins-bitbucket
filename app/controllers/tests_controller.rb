class TestsController < ApplicationController
  def show
    @pull_requests = bitbucket_client.prs
  end
end
