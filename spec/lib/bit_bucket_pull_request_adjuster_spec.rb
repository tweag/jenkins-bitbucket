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


  subject do
    described_class.new(client, message_adjuster: message_adjuster)
  end
  let(:message_adjuster) do
    double(call: {
      title: "adjusted title",
      description: "adjusted description"
    })
  end
  let(:client) { double(prs: pull_requests, update_pr: nil) }
  let(:pull_requests) {}

  describe "#update_status" do
    let(:story_id) { "123" }
    let(:job_status) { double(job_name: "job-name-#{story_id}") }

    context 'when a pull request exists for the story' do
      let(:pull_request) do
        double(id: 42, title: "pr #{story_id}" , description: "this is my pr")
      end
      let(:pull_requests) do
        [
          double(id: 1, title: "pr 012"),
          pull_request,
          double(id: 3, title: "pr 234")
        ]
      end

      it "updates the pull request description with the status" do
        subject.update_status job_status

        expect(client).to have_received(:update_pr)
          .with(42, "adjusted title", "adjusted description")
      end

      it "uses the pr and job status to generate the new message and title" do
        subject.update_status job_status

        expect(message_adjuster).to have_received(:call)
          .with(pull_request, job_status)
      end
    end

    context 'when a pull request does not exist for the story' do
      let(:pull_requests) do
        [
          double(id: 1, title: "pr 012"),
          double(id: 3, title: "pr 234")
        ]
      end
      it 'does not update any pr' do
        subject.update_status job_status

        expect(client).to_not have_received(:update_pr)
      end
    end
  end

  describe "#update_status_from_pull_request" do
    let(:pull_request) { double(id: 42) }
    let(:job_status)   { }

    it "updates the status of the pull request" do
      subject.update_status_from_pull_request job_status, pull_request

      expect(client).to have_received(:update_pr)
        .with(42, "adjusted title", "adjusted description")
    end

    it "uses the pr and job status to generate the new message and title" do
      subject.update_status_from_pull_request job_status, pull_request

      expect(message_adjuster).to have_received(:call)
        .with(pull_request, job_status)
    end
  end
end
