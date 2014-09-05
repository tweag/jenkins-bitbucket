require 'spec_helper'

describe 'Bitbucket pull request is made', type: :request, vcr: true do
  before { decline_all_pull_requests }

  def pull_request_notification_of(pull_request)
    post bitbucket_hook_path, pullrequest_created: pull_request
  end

  let(:pull_request)         { reset_pull_request }
  let(:original_description) { pull_request.description }
  let(:updated_pull_request) { reload_pull_request(pull_request) }
  let(:updated_description)  { updated_pull_request.description }
  let(:updated_title)        { updated_pull_request.title }

  def associated_job_exists
    post jenkins_hook_path, JenkinsJobExample.attributes(
      'build' => {
        'status' => 'ABORTED',
        'scm' => { 'branch' => 'origin/my-branch' }
      }
    )
  end

  context 'and there is no associated job' do
    it 'leaves a comment that there is no associated job' do
      pull_request_notification_of(pull_request)
      expect(updated_description).to include original_description
      expect(updated_description).to include '* * *'
      expect(updated_description).to include 'No job'
    end
  end

  context 'and there is an associated job' do
    before { associated_job_exists }

    it 'leaves a comment with the status' do
      pull_request_notification_of(pull_request)
      expect(updated_description).to include original_description
      expect(updated_description).to include '* * *'
      expect(updated_description).to include 'ABORTED'
    end
  end

  describe 'and then edited' do
    before { associated_job_exists }

    it 'can be updated by clicking a link in the pull request' do
      pull_request_notification_of pull_request

      updated_pull_request = reload_pull_request(pull_request)
      refresh_url = bitbucket_refresh_path(updated_pull_request.id)
      expect(updated_pull_request.description).to include refresh_url

      new_description = 'Changed description'
      update_pull_request_description pull_request, new_description

      post refresh_url, back_to: 'http://example.com'
      expect(response).to redirect_to 'http://example.com'

      updated_pull_request = reload_pull_request(pull_request)
      expect(updated_pull_request.description).to include new_description
      expect(updated_pull_request.description).to include '* * *'
      expect(updated_pull_request.description).to include 'ABORTED'
    end
  end
end
