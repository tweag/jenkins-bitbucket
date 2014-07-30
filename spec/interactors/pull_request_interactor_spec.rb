require 'spec_helper'

describe PullRequestInteractor do
  describe '.call' do
    subject { described_class.new(bitbucket: bitbucket) }

    let(:bitbucket) { double }
    let(:params)    { { action => { 'id' => 42 } } }

    describe 'a pull request created' do
      let(:action) { 'pullrequest_created' }

      before do
        allow(bitbucket).to receive(:update_status_from_pull_request)
      end

      it 'add the status to the pull request' do
        subject.call(params)
        expect(bitbucket).to have_received(:update_status_from_pull_request)
          .with(BitbucketClient::PullRequest.new('id' => 42))
      end
    end

    describe 'a pull request edited' do
      let(:action) { 'pullrequest_edited' }

      it 'does nothing and does it without exploding' do
        subject.call(params)
      end
    end
  end
end
