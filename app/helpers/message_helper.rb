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

  def checkmark_for_story_number(pull_request)
    # rubocop:disable Style/CaseEquality
    # It can be a proc, regexp, or otherwise
    if STORY_NUMBER_CHECKER === pull_request.title
      checkmark_good('Pull request title contains story number')
    else
      checkmark_bad('Pull request title does not contain story number '\
                    "(i.e. it does not match `#{STORY_NUMBER_CHECKER}`)")
    end
  end

  def checkmark_for_shas(message)
    return unless message[:job] && message[:pull_request]

    if message[:job].sha == message[:pull_request].sha
      checkmark_good('PR and Jenkins job SHAs are up to date with each other')
    else
      checkmark_bad('PR and Jenkins job SHAs do not match. '\
                    'One of them is out of date. '\
                    'Either update this PR or rerun the Jenkins job.')
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
