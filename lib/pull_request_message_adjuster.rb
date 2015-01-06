class PullRequestMessageAdjuster
  DEFAULT_SEPARATOR = '* * * * * * * * * * * * * * *'

  attr_accessor :separator, :title_adjuster, :renderer

  def initialize(
    separator:      DEFAULT_SEPARATOR,
    title_adjuster: TitleAdjuster.new,
    renderer:)
    self.separator      = separator
    self.title_adjuster = title_adjuster
    self.renderer       = renderer
  end

  def call(status_message)
    {
      title:       adjust_title(status_message),
      description: adjust_description(status_message)
    }
  end

  def adjust_description(status_message)
    status_message.pull_request.description =
      description_without_status(status_message.original_description)

    [
      status_message.pull_request.description,
      separator,
      renderer.call(status_message)
    ].join("\n")
  end

  def description_without_status(description)
    index = description.index(separator)
    if index
      description[0, index].strip
    else
      description
    end
  end

  def adjust_title(status_message)
    title_adjuster.call(status_message)
  end
end
