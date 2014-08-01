module MessageHelper
  def refresh_link(pull_request)
    md_link_to 'refresh this message',
               "#{root_url}/bitbucket/refresh/#{pull_request.id}"
  end

  def status(job)
    job.status || job.phase
  end

  def status_image(job)
    status_name = status(job)
    image = case status_name
            when 'SUCCESS'             then 'success.png'
            when 'FAILURE', 'UNSTABLE' then 'failure.png'
            when 'STARTED'             then 'working.png'
            else ''
            end

    md_image(status_name, image_url(image))
  end
end
