class JenkinsHooksController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    jenkins_handler.call params
    render text: "Thanks"
  end

  def index
    render text: "Point Jenkins to this URL"
  end
end
