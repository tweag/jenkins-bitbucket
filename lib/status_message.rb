# rubocop:disable Style/CaseEquality
class StatusMessage < Struct.new(:pull_request, :job, :commits)
  def status
    job && (job.status || job.phase)
  end

  def title_contains_story_number?(checker = STORY_NUMBER_CHECKER)
    # It can be a proc, regexp, or otherwise
    checker === pull_request.title
  end

  def branch_name_contains_story_number?(checker = STORY_NUMBER_CHECKER)
    # It can be a proc, regexp, or otherwise
    checker === pull_request.branch
  end

  def shas_match?
    job.sha == pull_request.sha
  end

  def no_wip_commits?
    messages = commits.map { |commit| commit['message'].lines.first }
    messages.grep(/\bWIP\b/i).empty?
  end

  def ready_to_review?
    status == 'SUCCESS' &&
      title_contains_story_number? &&
      branch_name_contains_story_number? &&
      no_wip_commits? &&
      shas_match?
  end
end
