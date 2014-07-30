class BitbucketPullRequestMessageAdjuster
  DEFAULT_SEPARATOR = '* * * * * * * * * * * * * * *'

  attr_accessor :separator, :formatter

  def initialize(separator: DEFAULT_SEPARATOR, formatter:)
    self.separator = separator
    self.formatter = formatter
  end

  def call(pull_request, job)
    {
      title:       pull_request.title,
      description: [
        description_without_status(pull_request.description),
        separator,
        formatter.call(pull_request, job)
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
