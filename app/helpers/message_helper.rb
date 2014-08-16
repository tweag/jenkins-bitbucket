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

  def checkmark_for_shas(message)
    return unless message[:job] && message[:pull_request]

    if message[:job].sha == message[:pull_request].sha
      checkmark_good('SHAs match')
    else
      checkmark_bad('Pull request and job SHAs do not match. '\
        'One of them is out of date')
    end
  end

  def checkmark_good(string)
    checkmark(':thumbsup: ') + string
  end

  def checkmark_bad(string)
    checkmark(':x: ') + string
  end

  def checkmark(string)
    '* ' + string
  end
end
