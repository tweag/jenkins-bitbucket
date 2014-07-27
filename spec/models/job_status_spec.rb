require 'spec_helper'

describe JobStatus do
  subject do
    JobStatus.new(
      "name"  => "the-name",
      "url"   => "job/test-job-for-webhooks/",
      "build" =>
      {
        "full_url" => "http://example.com/the-full-url",
        "number"   => 3,
        "phase"    => "the-phase",
        "status"   => "the-status",
        "url"      => "job/test-job-for-webhooks/3/",
        "scm"      =>
        {
          "url"    => "git@bitbucket.org:mountdiablo/ce_bacchus.git",
          "branch" => "origin/master",
          "commit" => "9a6e22c90bb0c90781dcf6f4ff94b52f97d80883"
        },
        "artifacts"  => {}
      }
    )
  end

  its(:job_name) { should eq "the-name" }
  its(:phase) { should eq "the-phase" }
  its(:status) { should eq "the-status" }
  its(:url) { should eq  "http://example.com/the-full-url"}

  context "when it has no status" do
    subject { JobStatus.new("build" => {}) }
    its(:status) { should be nil }
  end
end
