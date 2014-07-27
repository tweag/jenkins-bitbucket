require 'spec_helper'
require 'bit_bucket_client'

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
    let(:pull_request) { reload_pull_request(original_pull_request) }

    context 'and there is no jenkins status in it' do
      it 'leaves a comment on it' do
        act
        description = pull_request['description']
        expect(description).to include '* * *'
        expect(description).to include status
        expect(description).to include phase
        expect(description).to include url
      end
    end

    # context 'and there is a jenkins status in it' do
    #   let!(:pull_request) { create_pull_request_with_comments }
    #   it 'updates the comment with the current status' do
    #     act status: 'old-status'
    #     comment0 = user_leaves_comment
    #     act status: 'new-status'
    #     comment2 = user_leaves_comment
    #
    #     expect(comments[0]).to eq comment0
    #
    #     expect(comments[1]).to contain 'new-status'
    #     expect(comments[1]).not_to contain 'old-status'
    #
    #     expect(comments[2]).to eq comment2
    #   end
    # end
  end

  def act
    post '/hooks/jenkins', params
  end

  let(:params) do
    {
      "name"  => job_name,
      "url"   => "job/test-job-for-webhooks/",
      "build" =>
      {
        "full_url" => url,
        "number"   => 3,
        "phase"    => phase,
        "status"   => status,
        "url"      => "job/test-job-for-webhooks/3/",
        "scm"      =>
        {
          "url"    => "git@bitbucket.org:mountdiablo/ce_bacchus.git",
          "branch" => "origin/master",
          "commit" => "9a6e22c90bb0c90781dcf6f4ff94b52f97d80883"
        },
        "artifacts"  => {}
      }
    }
  end

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
