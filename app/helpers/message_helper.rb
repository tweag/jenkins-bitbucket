module MessageHelper
  def refresh_link(pull_request)
    md_link_to 'refresh this message',
               bitbucket_refresh_url(pull_request.id, back_to: pull_request.url)
  end

  def status(job)
    job.status || job.phase
  end

  def status_image(job)
    status_name = status(job)
    image = case status_name
            when 'SUCCESS'                        then 'success.png'
            when 'FAILURE', 'UNSTABLE', 'ABORTED' then 'failure.png'
            when 'STARTED'                        then 'working.png'
            else ''
            end

    md_image(status_name, image_url(image))
  end

  def checkmark_for_story_number(pull_request)
    # rubocop:disable Style/CaseEquality
    # It can be a proc, regexp, or otherwise
    if STORY_NUMBER_CHECKER === pull_request.title
      checkmark_good(t('messages.pull_request_story_number.good'))
    else
      checkmark_bad(
        t('messages.pull_request_story_number.bad',
          example: STORY_NUMBER_CHECKER)
      )
    end
  end

  def checkmark_for_shas(message)
    return unless message[:job] && message[:pull_request]

    if message[:job].sha == message[:pull_request].sha
      checkmark_good(t('messages.shas_match.good'))
    else
      checkmark_bad(t('messages.shas_match.bad'))
    end
  end

  def checkmark_good(string)
    ':thumbsup: ' + string
  end

  def checkmark_bad(string)
    ':x: ' + string
  end
end
