class PullRequestMessageAdjuster
  DEFAULT_SEPARATOR = '* * * * * * * * * * * * * * *'

  attr_accessor :separator, :renderer

  def initialize(separator: DEFAULT_SEPARATOR, renderer:)
    self.separator = separator
    self.renderer  = renderer
  end

  def call(pull_request, job)
    {
      title:       pull_request.title,
      description: [
        description_without_status(pull_request.description),
        separator,
        renderer.call(pull_request, job)
      ].join("\n")
    }
  end

  def description_without_status(description)
    index = description.index(separator.reverse)
    if index
      description[0, index].strip
    else
      description
    end
  end
end
