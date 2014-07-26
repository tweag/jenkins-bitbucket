require 'spec_helper'

class JenkinsHandler
  def initialize(jenkins:, bitbucket:)
    @jenkins   = jenkins
    @bitbucket = bitbucket
  end

  def handle(params)
    @jenkins.upsert_job params
    @bitbucket.comment params
  end
end

describe JenkinsHandler, '.handle' do
  let(:params) do
    {
      "name"  => "test-job-for-webhooks",
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
  let(:status) {}

  subject { JenkinsHandler.new(jenkins: jenkins, bitbucket: bitbucket) }
  let(:jenkins)   { double upsert_job: nil }
  let(:bitbucket) { double comment: nil }

  before do
    subject.handle(params)
  end

  describe "a job started" do
    let(:phase) { "STARTED" }

    it 'upserts the job' do
      expect(jenkins).to have_received(:upsert_job).with(params)
    end

    it 'add the comment on bitbuket' do
      expect(bitbucket).to have_received(:comment).with(params)
    end
  end

  describe "success" do
    let(:status) { "SUCCESS" }

    describe "a job succeeded" do
      let(:phase) { "COMPLETED" }
    end

    describe "a job finalized (success)" do
      let(:phase) { "FINALIZED" }
    end
  end

  describe "failure" do
    let(:status) { "FAILURE" }

    describe "a job succeeded" do
      let(:phase) { "COMPLETED" }
    end

    describe "a job finalized (success)" do
      let(:phase) { "FINALIZED" }
    end
  end

  describe "aborted" do
    let(:status) { "ABORTED" }

    describe "a job succeeded" do
      let(:phase) { "COMPLETED" }
    end

    describe "a job finalized (success)" do
      let(:phase) { "FINALIZED" }
    end
  end
end
