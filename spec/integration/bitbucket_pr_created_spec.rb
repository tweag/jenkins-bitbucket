require 'spec_helper'

describe 'BitBucket PR is made' do
  before { decline_all_pull_requests }

  def pull_request_happens
    post '/hooks/bitbucket', pullrequest_created: pull_request
  end

  let(:pull_request)         { create_pull_request(title) }
  let(:title)                { "My Pull Request PR-123" }
  let(:original_description) { pull_request['description'] }

  context 'and there is no associated job' do
    let(:updated_description) do
      reload_pull_request(pull_request)['description']
    end

    it 'leaves a comment that there is no associated job' do
      pull_request_happens
      expect(updated_description).to include original_description
      expect(updated_description).to include "* * *"
      expect(updated_description).to include "UNKNOWN"
    end
  end

  context 'and there is an associated job' do
    it 'leaves a comment with the status'
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
