class JenkinsHooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    jenkins_handler.call params
    render text: "Thanks"
  end
end

