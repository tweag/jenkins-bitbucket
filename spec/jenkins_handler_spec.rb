require 'spec_helper'
require 'jenkins_handler'

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
  let(:bitbucket) { double update_status: nil }

  before do
    subject.call(params)
  end

  describe "a job started" do
    let(:phase) { "STARTED" }

    it 'upserts the job' do
      expect(jenkins).to have_received(:upsert_job)
    end

    it 'add the update_status on bitbuket' do
      expect(bitbucket).to have_received(:update_status)
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
