class TitleAdjuster
  attr_accessor :good, :bad, :running

  def initialize(good: '✔︎', bad: '✗', running: '…')
    self.good    = good
    self.bad     = bad
    self.running = running
  end

  def call(message)
    title = message.pull_request.title
    status = case
             when message.ready_to_review?                    then good
             when message.ready_to_review_assuming_it_passes? then running
             else bad
             end

    title.sub(/^(#{good}|#{bad}|#{running})?\s*/, "#{status} ")
  end
end
