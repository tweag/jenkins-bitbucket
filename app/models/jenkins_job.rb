class JenkinsJob < ActiveRecord::Base
  def self.save_job_status(job_status)
    find_or_initialize_by(id: job_status.job_number)
      .update_attributes(data: job_status.as_json)
  end

  def self.get_job_status(job_number)
    jenkins_job = find_by_id(job_number) or return
    JobStatus.new(jenkins_job.data)
  end
end
