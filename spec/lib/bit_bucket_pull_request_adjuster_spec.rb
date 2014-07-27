require 'spec_helper'
require 'bit_bucket_pull_request_adjuster'

describe BitBucketPullRequestAdjuster do
  describe ".extract_id" do
    context "when it contains a number" do
      it "extracts the number" do
        [
          "something-another-234",
          "something234",
          "234",
          "something234another",
          "something098098-234",
          "234something",
          "234 something",
          "something 234",
        ].each do |str|
          expect(described_class.extract_id(str)).to eq "234"
        end
      end
    end

    context "when it doesn't contain a number" do
      it "extracts the number" do
        [
          "something-another",
          "something",
          "",
          "something another",
          " something-",
        ].each do |str|
          expect(described_class.extract_id(str)).to be nil
        end
      end
    end
  end

  describe "#update_status" do
    subject { described_class.new(client) }
    let(:client) { double(prs: pull_requests, update_pr: nil) }

    def act
      subject.update_status job_status
    end

    let(:story_id) { "123" }
    let(:job_status) do
      double(job_name: "job-name-#{story_id}")
    end

    context 'when a pull request exists for the story' do
      let(:pull_requests) do
        [
          double(id: 1, title: "pr 012"),
          double(id: 2, title: title, description: description),
          double(id: 3, title: "pr 234")
        ]
      end
      let(:title) { "pr #{story_id}" }

      context 'and the description does not contain the status' do
        let(:description) { "this is my pr" }
        before { subject.status_renderer = proc { "this is the status" } }
        let(:expected_description) { "this is my pr\nthis is the status" }

        it "updates the pull request description with the status" do
          act
          expect(client).to have_received(:update_pr)
            .with(2, title, expected_description)
        end
      end
    end
  end

  context 'when a pull request does not exist for the story' do

  end

  describe ".job_status_markdown" do
    let(:job_status) do
      double(
        job_name: "my-job",
        status:   "the-status",
        phase:    "the-phase",
        url:      "http://example.com"
      )
    end

    subject { described_class.job_status_markdown(job_status) }

    it { should include "* * *" }
    it { should include job_status.job_name }
    it { should include job_status.phase }
    it { should include job_status.status }
    it { should include job_status.url }
  end
end
