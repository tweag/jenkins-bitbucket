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
    let(:job_name)      { "job-name-for-existant-pr" }

    before              { decline_all_pull_requests }
    let!(:pull_request) { create_pull_request }

    let(:comments) { comments_for(pull_request) }

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
  end

  class BitBucket
    PRS = "/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests"

    def initialize
      @conn = Faraday.new(:url => 'https://api.bitbucket.org') do |faraday|
        faraday.request :basic_auth, 'jenkins-bitbucket', 'NXTUpRQGeJMokuQAnQcWqnGbvsMsAqn9DwqcFGTseNaGJWLCy3'
        faraday.request :json
        faraday.response :json
        faraday.adapter  Faraday.default_adapter
      end
    end

    def create_pr
      post(PRS,
        "source" => { "branch" => { "name" => "my-branch" }, },
        "title" => "my-pr",
        "description" => "it's a pr"
      )
    end

    def post(url, body = nil)
      @conn.post do |req|
        req.url url
        if body.present?
          req.headers['Content-Type'] = 'application/json'
          req.body = body.to_json
        end
      end.body
    end

    def get(str)
      @conn.get(str).body
    end

    def prs
      get(PRS)['values']
    end

    def comments(id)
      get("#{PRS}/#{id}/comments")['values']
    end

    def decline_pr(id)
      post("#{PRS}/#{id}/decline")
    end
  end

  let(:bitbucket) { BitBucket.new }

  def create_pull_request
    bitbucket.create_pr
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
end
