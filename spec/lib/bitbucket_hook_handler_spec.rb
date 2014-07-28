require 'spec_helper'
require 'bitbucket_hook_handler'

describe BitbucketHookHandler, '.call' do
  let(:params) do
    { action => { "id" => 42 } }
  end

  subject { described_class.new(jenkins: jenkins, bitbucket: bitbucket) }
  let(:jenkins)   { double }
  let(:bitbucket) { double }

  before do
  end

  describe "a pull request created" do
    let(:action) { "pullrequest_created" }

    before do
      allow(bitbucket).to receive(:update_status_from_pull_request)
    end

    it "add the status to the pull request" do
      subject.call(params)
      expect(bitbucket).to have_received(:update_status_from_pull_request)
        .with(nil, BitBucketClient::PullRequest.new("id" => 42))
    end
  end

  describe "a pull request edited" do
    let(:action) { "pullrequest_edited" }

    it "does nothing" do
      subject.call(params)
    end
  end
end
