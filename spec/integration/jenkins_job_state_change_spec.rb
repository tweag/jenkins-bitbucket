require 'spec_helper'

describe 'Jenkins job changes state', type: :request do
  let(:status)   { "NEW-STATUS" }
  let(:phase)    { "STARTED" }
  let(:full_url) { 'http://example.com/jenkins/jobs/42' }

  context 'and there is no PR' do
    let(:job_name) { "job-name-for-non-existant-pr" }
    it 'does nothing' do
      act

      all_comments_on_all_prs.each do |comment|
        expect(comment).not_to match job_name
      end
    end
  end

  context 'and there is PR' do
    let!(:pull_request) { create_pull_request }
    let(:comments)      { comments_for(pull_request) }

    context 'and there is no comment on it' do
      it 'leaves a comment on it' do
        act
        expect(comments).to have(1).comment
        expect(comments.first).to contain status
        expect(comments.first).to contain full_url
      end
    end

    context 'and there is a comment on it' do
      let!(:pull_request) { create_pull_request_with_comments }
      it 'updates the comment with the current status' do
        act status: 'old-status'
        comment0 = user_leaves_comment
        act status: 'new-status'
        comment2 = user_leaves_comment

        expect(comments[0]).to eq comment0

        expect(comments[1]).to contain 'new-status'
        expect(comments[1]).not_to contain 'old-status'

        expect(comments[2]).to eq comment2
      end
    end
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
        "full_url" => "http://ucp-jenkins:8080/job/test-job-for-webhooks/3/",
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

  let(:bitbucket) do
    BitBucket.new(
      'jenkins-bitbucket',
      'NXTUpRQGeJMokuQAnQcWqnGbvsMsAqn9DwqcFGTseNaGJWLCy3'
    )
  end

  class BitBucket
    include HTTParty
    format :json
    base_uri "https://api.bitbucket.org/2.0"

    def initialize(login, password)
      self.class.basic_auth login, password
    end

    def prs
      self.class.get(PRS)
    end

    PRS = "/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests"

    def comments_for_pr(id)
      self.class.get("#{PRS}/#{id}/comments")
    end
  end

  def all_comments_on_all_prs
    bitbucket.prs['values'].map do |pr|
      bitbucket.comments_for_pr(pr['id'])['values']
    end.reduce(&:+)
  end
end
