require 'spec_helper'

describe 'Bitbucket PR is made', vcr: true do
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

  def associated_job_exists
    post '/hooks/jenkins', job_params(
      job_name: "job-#{story_number}",
      status: "ABORTED"
    )
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
    before { associated_job_exists }

    it 'leaves a comment with the status' do
      pull_request_notification_of(pull_request)
      expect(updated_description).to include original_description
      expect(updated_description).to include "* * *"
      expect(updated_description).to include "ABORTED"
    end
  end

  describe "and then edited" do
    before { associated_job_exists }

    it 'can be updated by clicking a link in the PR' do
      pull_request_notification_of(pull_request)

      updated_pull_request = reload_pull_request(pull_request)
      refresh_url = "/bitbucket/refresh/#{updated_pull_request['id']}"
      expect(updated_pull_request['description']).to include refresh_url

      update_pull_request_description pull_request, "Changed description"

      post refresh_url
      updated_pull_request = reload_pull_request(pull_request)
      expect(updated_pull_request['description']).to include "Changed description"
      expect(updated_pull_request['description']).to include "* * *"
      expect(updated_pull_request['description']).to include "ABORTED"
    end
  end
end
