module MessageHelper
  def refresh_link(pull_request)
    md_link_to 'refresh this message',
               bitbucket_refresh_url(pull_request.id, back_to: pull_request.url)
  end

  def automerge_link(pull_request, on_or_off)
    md_link_to '[toggle]', bitbucket_automerge_url(
      pull_request.id,
      turn:    on_or_off,
      back_to: pull_request.url
    )
  end

  def status_image(message)
    image = case message.status
            when 'SUCCESS'                        then 'success.png'
            when 'FAILURE', 'UNSTABLE', 'ABORTED' then 'failure.png'
            when 'STARTED'                        then 'working.png'
            else ''
            end

    md_image(message.status, image_url(image))
  end

  def checkmark_for(property, message)
    if message.public_send("#{property}?")
      checkmark_good(t("messages.#{property}.good"))
    else
      checkmark_bad(
        t(
          "messages.#{property}.bad",
          example: Configuration.instance.story_number_example
        )
      )
    end
  end

  def checkmark_good(string)
    ':thumbsup: ' + string
  end

  def checkmark_bad(string)
    ':x:        ' + string
  end

  def data(message)
    EmbeddedData.dump(message.pull_request.embedded_data).html_safe
  end
end
