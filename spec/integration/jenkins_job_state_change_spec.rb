require 'spec_helper'

describe 'Jenkins job changes state', type: :request do
  let(:status) { "NEW-STATUS" }
  let(:phase)  { "STARTED" }
  let(:url)    { 'http://example.com/jenkins/jobs/42' }

  context 'and there is no PR' do
    let(:job_name) { "job-name-for-non-existant-pr" }
    it 'does nothing' do
      act
    end
  end

  context 'and there is a PR' do
    let(:job_name) { "job-4958" }
    let(:pr_title) { "pr  4958" }

    before { decline_all_pull_requests }
    let!(:original_pull_request) { create_pull_request(pr_title) }
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

  # TODO: move all this somewhere else
  let(:bitbucket) { BitBucketClient.new }

  def create_pull_request(title)
    bitbucket.create_pr(title)
  end

  def decline_all_pull_requests
    bitbucket.prs.each do |pr|
      bitbucket.decline_pr pr['id']
    end
  end

  def comments_for(pr)
    bitbucket.comments(pr['id'])
  end

  def all_comments_on_all_prs
    bitbucket.prs.map do |pr|
      bitbucket.comments(pr['id'])
    end.reduce(&:+)
  end

  def reload_pull_request(pr)
    bitbucket.pr(pr['id'])
  end
end
