class TestsController < ApplicationController
  def show
    @pull_requests = bit_bucket_client.prs
  end
end
