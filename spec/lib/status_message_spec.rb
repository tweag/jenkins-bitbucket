describe StatusMessage do
  subject(:status_message) { described_class.new(pull_request, job, commits) }

  let(:pull_request) { double }
  let(:job)          { double }
  let(:commits)      { [] }

  describe '#status' do
    context 'when there is no job' do
      let(:job) { nil }
      its(:status) { is_expected.to be nil }
    end

    context 'when the job has a status' do
      let(:job) { double(build_status: 'the-status') }
      its(:status) { is_expected.to eq 'the-status' }
    end
  end

  describe '#title_contains_story_number?' do
    subject { status_message.title_contains_story_number?(/\d/) }

    context 'when the title contains a story number' do
      let(:pull_request) { double(title: 'a1') }
      it { is_expected.to be true }
    end

    context 'when the title does not contain a story number' do
      let(:pull_request) { double(title: 'a') }
      it { is_expected.to be false }
    end
  end

  describe '#branch_name_contains_story_number?' do
    subject { status_message.branch_name_contains_story_number?(/\d/) }

    context 'when the branch name contains a story number' do
      let(:pull_request) { double(PullRequest, branch: 'story/7') }
      it { is_expected.to be true }
    end

    context 'when the branch name does not contain a story number' do
      let(:pull_request) { double(PullRequest, branch: 'my-story') }
      it { is_expected.to be false }
    end
  end

  describe '#shas_match?' do
    subject { status_message.shas_match? }

    context 'when the shas match' do
      let(:pull_request) { double(sha: 'a') }
      let(:job)          { double(sha: 'a') }

      it { is_expected.to be true }
    end

    context 'when the shas do not match' do
      let(:pull_request) { double(sha: 'a') }
      let(:job)          { double(sha: 'z') }

      it { is_expected.to be false }
    end
  end

  describe '#no_wip_commits?' do
    context 'when one of the commits is a wip commit' do
      let(:commits) do
        [
          { 'message' => 'normal' },
          { 'message' => 'a Wip commit' }
        ]
      end
      it { is_expected.to_not be_no_wip_commits }
    end

    context 'when none of the commits are wip commits' do
      let(:commits) { [{ 'message' => 'normal commit' }] }
      it { is_expected.to be_no_wip_commits }
    end

    context 'when there are no commits' do
      let(:commits) { [] }
      it { is_expected.to be_no_wip_commits }
    end
  end

  describe '#ready_to_review?' do
    let(:job) do
      double(JenkinsJob, started?: false, success?: success?, sha: job_sha)
    end

    let(:pull_request) do
      double(
        PullRequest,
        title:  pull_request_title,
        sha:    pull_request_sha,
        branch: pull_request_branch
      )
    end

    let(:pull_request_title)  { 'a1' }
    let(:pull_request_branch) { 'a1' }
    let(:pull_request_sha)    { 'a' }
    let(:success?)            { true }
    let(:job_sha)             { 'a' }

    context 'when all is well' do
      it { is_expected.to be_ready_to_review }
    end

    context 'when the job is not started' do
      let(:success?) { false }
      it { is_expected.to_not be_ready_to_review }
    end

    context 'when the shas do not match' do
      let(:job_sha) { 'z' }
      it { is_expected.to_not be_ready_to_review }
    end

    context 'when the title does not contain a story number' do
      let(:pull_request_title) { 'a' }
      it { is_expected.to_not be_ready_to_review }
    end

    context 'when the branch does not contain a story number' do
      let(:pull_request_branch) { 'a' }
      it { is_expected.to_not be_ready_to_review }
    end

    context 'when one of the commits is a wip commit' do
      let(:commits) { [{ 'message' => 'WIP' }] }
      it { is_expected.to_not be_ready_to_review }
    end
  end

  describe '#ready_to_review_assuming_it_passes?' do
    let(:job) do
      double(JenkinsJob, success?: false, started?: started?, sha: job_sha)
    end

    let(:pull_request) do
      double(
        PullRequest,
        title:  pull_request_title,
        sha:    pull_request_sha,
        branch: pull_request_branch
      )
    end

    let(:pull_request_title)  { 'a1' }
    let(:pull_request_branch) { 'a1' }
    let(:pull_request_sha)    { 'a' }
    let(:started?)            { true }
    let(:job_sha)             { 'a' }

    context 'when all is well' do
      it { is_expected.to be_ready_to_review_assuming_it_passes }
    end

    context 'when the job is running' do
      let(:started?) { false }
      it { is_expected.to_not be_ready_to_review_assuming_it_passes }
    end

    context 'when the shas do not match' do
      let(:job_sha) { 'z' }
      it { is_expected.to be_ready_to_review_assuming_it_passes }
    end

    context 'when the title does not contain a story number' do
      let(:pull_request_title) { 'a' }
      it { is_expected.to_not be_ready_to_review_assuming_it_passes }
    end

    context 'when the branch does not contain a story number' do
      let(:pull_request_branch) { 'a' }
      it { is_expected.to_not be_ready_to_review_assuming_it_passes }
    end

    context 'when one of the commits is a wip commit' do
      let(:commits) { [{ 'message' => 'WIP' }] }
      it { is_expected.to_not be_ready_to_review_assuming_it_passes }
    end
  end
end
