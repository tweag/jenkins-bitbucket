class JenkinsJobsController < ApplicationController
  def index
    @jenins_jobs = JenkinsJob.all
  end
end
