class JenkinsJob < ActiveRecord::Base
  def self.store(job)
    job.identifier &&
      find_or_initialize_by(identifier: job.identifier.to_s)
        .update_attributes(data: job.as_json)
  end

  def self.[](identifier)
    jenkins_job = find_by_identifier(identifier.to_s) || return
    new_from_jenkins(jenkins_job.data)
  end

  def self.new_from_jenkins(data)
    new(data: data).tap do |job|
      job.identifier = job.identifier
    end
  end

  def ==(other)
    identifier == other.identifier
  end

  def identifier
    Util.extract_id(name)
  end

  def name
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

  def sha
    build('scm')['commit']
  end

  def as_json(*args)
    data.as_json(*args)
  end

  private

  def build(*args)
    data.fetch('build').fetch(*args)
  end
end
