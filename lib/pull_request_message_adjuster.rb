class PullRequestMessageAdjuster
  DEFAULT_SEPARATOR = '* * * * * * * * * * * * * * *'

  attr_accessor :separator, :renderer

  def initialize(separator: DEFAULT_SEPARATOR, renderer:)
    self.separator = separator
    self.renderer  = renderer
  end

  def call(status_message)
    {
      title:       status_message.pull_request.title,
      description: [
        description_without_status(status_message.pull_request.description),
        separator,
        renderer.call(status_message.pull_request, status_message.job)
      ].join("\n")
    }
  end

  def description_without_status(description)
    index = description.index(separator)
    if index
      description[0, index].strip
    else
      description
    end
  end
end
