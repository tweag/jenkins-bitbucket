class StatusMessage < Struct.new(:pull_request, :job)
  def status
    job.status || job.phase
  end

  def title_contains_story_number?
    # rubocop:disable Style/CaseEquality
    # It can be a proc, regexp, or otherwise
    STORY_NUMBER_CHECKER === pull_request.title
  end

  def shas_match?
    job.sha == pull_request.sha
  end
end
