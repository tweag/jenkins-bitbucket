describe 'Jenkins job changes state', type: :request, vcr: true do
  before { decline_all_pull_requests }

  def create_pull_request(description)
    bitbucket.create_pull_request(
      'source'      => { 'branch' => { 'name' => 'my-branch-123' } },
      'title'       => 'Example pull request 123',
      'description' => description
    )
  end

  def job_changes_state
    post jenkins_hook_path, JenkinsJobExample.attributes(
      'build' => {
        'status'   => 'SUCCESS',
        'full_url' => 'http://example.com/jenkins/jobs/42',
        'scm'      => {
          'commit' => '3bbb2bf',
          'branch' => 'origin/my-branch-123'
        }
      }
    )
  end

  def updated_title(pull_request)
    reload_pull_request(pull_request).title
  end

  it 'is marked as passing' do
    pull_request = create_pull_request 'Hi no image'

    job_changes_state
    expect(updated_title(pull_request)).to match(/✔︎/)
  end

  context 'when images are required' do
    before { Configuration.instance.image_required = true }

    it 'is marked as failing' do
      pull_request = create_pull_request 'Hi no image'

      job_changes_state
      expect(updated_title(pull_request)).to match(/✗/)

      job_changes_state
      expect(updated_title(pull_request)).to match(/✗/)
    end

    context 'with an image' do
      it 'is marked as passing' do
        pull_request = create_pull_request 'Hi ![image](http://google.com)'

        job_changes_state
        expect(updated_title(pull_request)).to match(/✔︎/)
      end
    end
  end
end
