require 'spec_helper'

describe 'BitBucket PR is made' do
  before { decline_all_pull_requests }

  def pull_request_notification_of(pr)
    post '/hooks/bitbucket', pullrequest_created: pr
  end

  let(:pull_request)         { create_pull_request(title) }
  let(:title)                { "My Pull Request PR-#{story_number}" }
  let(:story_number)         { "123" }
  let(:original_description) { pull_request['description'] }
  let(:updated_description) do
    reload_pull_request(pull_request)['description']
  end

  context 'and there is no associated job' do
    it 'leaves a comment that there is no associated job' do
      pull_request_notification_of(pull_request)
      expect(updated_description).to include original_description
      expect(updated_description).to include "* * *"
      expect(updated_description).to include "UNKNOWN"
    end
  end

  context 'and there is an associated job' do
    before do
      post '/hooks/jenkins', job_params(
        job_name: "job-#{story_number}",
        status: "ABORTED"
      )
    end

    it 'leaves a comment with the status' do
      pull_request_notification_of(pull_request)
      expect(updated_description).to include original_description
      expect(updated_description).to include "* * *"
      expect(updated_description).to include "ABORTED"
    end
  end
end

describe 'BitBucket PR is updated' do
  context 'and there is no associated job' do
    it 'leaves a comment that there is no associated job'
  end

  context 'and there is an associated job' do
    it 'leaves a comment with the status'
  end
end
