class JenkinsJobsController < ApplicationController
  def index
    @jenins_jobs = JenkinsJob.order('updated_at DESC')
  end
end
