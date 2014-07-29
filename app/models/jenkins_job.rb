require 'util'

class JenkinsJob < ActiveRecord::Base
  def self.save_job_status(job_status)
    find_or_initialize_by(id: job_status.job_number)
      .update_attributes(data: job_status.as_json)
  end

  def self.get_job_status(job_number)
    jenkins_job = find_by_id(job_number) or return
    new_from_jenkins(jenkins_job.data)
  end

  def self.new_from_jenkins(data)
    new(data: data).tap do |job|
      job.id = job.job_number
    end
  end

  def job_number
    Util.extract_id(job_name)
  end

  def job_name
    data.fetch('name')
  end

  def url
    build('full_url')
  end

  def status
    build('status', nil)
  end

  def phase
    build('phase')
  end

  def as_json(*args)
    data.as_json(*args)
  end

  private

  def build(*args)
    data.fetch('build').fetch(*args)
  end
end
