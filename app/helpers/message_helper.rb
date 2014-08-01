module MessageHelper
  def refresh_link(pull_request)
    md_link_to 'refresh this message',
               "#{root_url}/bitbucket/refresh/#{pull_request.id}"
  end

  def status(job)
    job.status || job.phase
  end
end
