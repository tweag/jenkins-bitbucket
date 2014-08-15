require 'spec_helper'

describe 'Jenkins job changes state', type: :request, vcr: true do
  let(:url) { 'http://example.com/jenkins/jobs/42' }

  context 'and there is no pull request' do
    it 'does nothing' do
      job_changes_state
    end
  end

  context 'and there is a pull request' do
    before { decline_all_pull_requests }
    let!(:original_pull_request) { reset_pull_request }
    let(:updated_description) do
      reload_pull_request(original_pull_request).description
    end

    context 'and there is no jenkins status in it' do
      it 'leaves a comment on it' do
        job_changes_state 'SUCCESS'
        expect(updated_description).to include '* * *'
        expect(updated_description).to include 'SUCCESS'
        expect(updated_description).to include url
      end
    end

    context 'and there is a jenkins status in it' do
      before { job_changes_state 'FAILURE' }

      it 'updates the pull request with the status' do
        job_changes_state status: 'SUCCESS'

        expect(updated_description).to include '* * *'
        expect(updated_description).to include url
        expect(updated_description).to include 'SUCCESS'
        expect(updated_description).not_to include 'FAILURE'
      end
    end
  end

  def job_changes_state(status = 'SUCCESS')
    post '/hooks/jenkins', JenkinsJobExample.attributes(
      'build' => {
        'status'   => status,
        'full_url' => url,
        'scm'      => { 'branch' => 'origin/my-branch' }
      }
    )
  end
end
