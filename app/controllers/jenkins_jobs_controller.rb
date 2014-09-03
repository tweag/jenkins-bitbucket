class JenkinsJobsController < ApplicationController
  def index
    @jenkins_jobs = JenkinsJob.order('updated_at DESC')
  end
end
