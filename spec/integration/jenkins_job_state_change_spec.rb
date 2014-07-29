require 'spec_helper'

describe 'Jenkins job changes state', vcr: true do
  let(:status) { "NEW-STATUS" }
  let(:phase)  { "STARTED" }
  let(:url)    { 'http://example.com/jenkins/jobs/42' }

  context 'and there is no pull request' do
    let(:job_name) { "job-name-for-non-existant-pull-request" }
    it 'does nothing' do
      act
    end
  end

  context 'and there is a pull request' do
    let(:job_name) { "job-4958" }
    let(:pull_request_title) { "pull request 4958" }

    before { decline_all_pull_requests }
    let!(:original_pull_request) { create_pull_request(pull_request_title) }
    let(:updated_description) do
      reload_pull_request(original_pull_request)['description']
    end

    context 'and there is no jenkins status in it' do
      it 'leaves a comment on it' do
        act
        expect(updated_description).to include '* * *'
        expect(updated_description).to include status
        expect(updated_description).to include url
      end
    end

    context 'and there is a jenkins status in it' do
      before { act status: 'old-status' }
      it 'updates the pull request with the status' do
        act status: 'new-status'

        expect(updated_description).to include '* * *'
        expect(updated_description).to include url
        expect(updated_description).to include 'new-status'
        expect(updated_description).not_to include 'old-status'
      end
    end
  end

  def act(options = {})
    post '/hooks/jenkins', job_params({
      job_name: job_name,
      status:   status,
      phase:    phase,
      url:      url
    }.merge(options))
  end
end
