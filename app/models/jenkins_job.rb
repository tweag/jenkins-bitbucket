class JenkinsJob < ActiveRecord::Base
  def self.store(job)
    job.story_number &&
      find_or_initialize_by(story_number: job.story_number.to_s)
        .update_attributes(data: job.as_json)
  end

  def self.[](story_number)
    jenkins_job = find_by_story_number(story_number.to_s) || return
    new_from_jenkins(jenkins_job.data)
  end

  def self.new_from_jenkins(data)
    new(data: data).tap do |job|
      job.story_number = job.story_number
    end
  end

  def ==(other)
    story_number == other.story_number
  end

  def story_number
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
