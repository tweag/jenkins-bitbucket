class TitleAdjuster
  attr_accessor :good, :bad

  def initialize(good: '✔︎', bad: '✗')
    self.good = good
    self.bad  = bad
  end

  def call(message)
    title = message.pull_request.title
    status = message.ready_to_review? ? good : bad
    title.sub(/^(#{good}|#{bad})?\s*/, "#{status} ")
  end
end
