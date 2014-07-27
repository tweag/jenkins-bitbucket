class JobStatus < Struct.new(:data)
  def job_name
    data.fetch('name')
  end

  def url
    build('full_url')
  end

  def status
    build('status')
  end

  def phase
    build('phase')
  end

  private

  def build(key)
    data.fetch('build').fetch(key)
  end
end
