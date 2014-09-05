class StatusMessage < Struct.new(:pull_request, :job)
  def status
    job && (job.status || job.phase)
  end

  def title_contains_story_number?(checker = STORY_NUMBER_CHECKER)
    # rubocop:disable Style/CaseEquality
    # It can be a proc, regexp, or otherwise
    checker === pull_request.title
  end

  def shas_match?
    job.sha == pull_request.sha
  end

  def ready_to_review?
    status == 'SUCCESS' &&
      title_contains_story_number? &&
      shas_match?
  end
end
