class PullRequestMessageAdjuster
  DEFAULT_SEPARATOR = '* * * * * * * * * * * * * * *'

  attr_accessor :separator, :renderer

  def initialize(separator: DEFAULT_SEPARATOR, renderer:)
    self.separator = separator
    self.renderer  = renderer
  end

  def call(status_message)
    {
      title:       adjust_title(status_message),
      description: adjust_description(status_message)
    }
  end

  def adjust_description(status_message)
    [
      description_without_status(status_message.pull_request.description),
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
    status_message.pull_request.title
  end
end
