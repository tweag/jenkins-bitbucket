require 'util'

class JobStatus < Struct.new(:data)
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
