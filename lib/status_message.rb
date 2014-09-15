# rubocop:disable Style/CaseEquality
class StatusMessage < Struct.new(:pull_request, :job, :commits)
  def status
    job.build_status
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

  def ready_to_review_assuming_it_passes?
    started? && well_formed_pull_request?
  end

  def ready_to_review?
    success? &&
      well_formed_pull_request? &&
      shas_match?
  end

  def well_formed_pull_request?
    title_contains_story_number? &&
      branch_name_contains_story_number? &&
      no_wip_commits?
  end

  def job?
    self[:job]
  end

  def job
    super || NullJob.new
  end

  class NullJob
    def build_status
    end

    def success?
    end

    def started?
    end

    def sha
    end
  end

  private

  def started?
    job.started?
  end

  def success?
    job.success?
  end
end
