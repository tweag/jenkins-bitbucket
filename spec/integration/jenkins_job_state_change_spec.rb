require 'spec_helper'

describe 'Jenkins job changes state', vcr: true do
  let(:url) { 'http://example.com/jenkins/jobs/42' }

  context 'and there is no pull request' do
    let(:job_name) { 'job-name-for-non-existant-pull-request' }

    it 'does nothing' do
      job_changes_state
    end
  end

  context 'and there is a pull request' do
    let(:job_name) { 'job-4958' }
    let(:pull_request_title) { 'pull request 4958' }

    before { decline_all_pull_requests }
    let!(:original_pull_request) { create_pull_request(pull_request_title) }
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
      'name' => job_name,
      'build' => {
        'status' => status,
        'full_url' => url
      }
    )
  end
end
