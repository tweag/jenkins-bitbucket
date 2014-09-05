class StatusMessage < Struct.new(:pull_request, :job)
  def status
    job.status || job.phase
  end
end
