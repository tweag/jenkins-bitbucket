require 'spec_helper'
require 'bitbucket_pull_request_adjuster'

describe BitbucketPullRequestAdjuster do
  describe '.match' do
    it { expect(described_class.match(123, 123)).to be_true }
    it { expect(described_class.match(123, nil)).to be_false }
    it { expect(described_class.match(nil, nil)).to be_false }
  end
end

describe BitbucketPullRequestAdjuster do
  subject do
    described_class.new(client,
                        message_adjuster: message_adjuster,
                        jenkins_jobs:     jenkins_jobs
                       )
  end

  let(:message_adjuster) { double }
  let(:pull_requests) {}
  let(:jenkins_jobs) { double }

  let(:client) do
    double(pull_requests: pull_requests, update_pull_request: nil)
  end

  before do
    allow(message_adjuster).to receive(:call)
      .with(pull_request, job).and_return(
        title:       'adjusted title',
        description: 'adjusted description'
      )
  end

  describe '#update_status' do
    let(:story_id) { '123' }
    let(:job) { build_job('name' => "job-name-#{story_id}") }

    context 'when a pull request exists for the story' do
      let(:pull_request) do
        double(
          id:          42,
          title:       "pull request #{story_id}",
          description: 'this is my pull request'
        )
      end
      let(:pull_requests) do
        [
          double(id: 1, title: 'pull request 012'),
          pull_request,
          double(id: 3, title: 'pull request 234')
        ]
      end

      it 'updates the pull request description with the status' do
        subject.update_status job

        expect(client).to have_received(:update_pull_request)
          .with(42, 'adjusted title', 'adjusted description')
      end
    end

    context 'when a pull request does not exist for the story' do
      let(:pull_requests) do
        [
          double(id: 1, title: 'pull request 012'),
          double(id: 3, title: 'pull request 234')
        ]
      end
      let(:pull_request) {}
      it 'does not update any pull request' do
        subject.update_status job

        expect(client).to_not have_received(:update_pull_request)
      end
    end
  end

  describe '#update_status_from_pull_request' do
    let(:pull_request) { double(id: 42, title: 'My Pull Request 123') }

    before do
      allow(jenkins_jobs).to receive(:fetch).with(123) { job }
    end

    context 'when there is no matching job' do
      let(:job) {}

      it 'updates the status of the pull request' do
        subject.update_status_from_pull_request pull_request

        expect(client).to have_received(:update_pull_request)
          .with(42, 'adjusted title', 'adjusted description')
      end
    end

    context 'when there is a matching job' do
      let(:job) { double }

      it 'updates the status of the pull request' do
        subject.update_status_from_pull_request pull_request

        expect(client).to have_received(:update_pull_request)
          .with(42, 'adjusted title', 'adjusted description')
      end
    end

    context 'when there is no story number in the title' do
      let(:pull_request) { double(id: 42, title: 'My Pull Request') }
      let(:job)   {}

      it 'updates the status of the pull request' do
        subject.update_status_from_pull_request pull_request

        expect(client).to have_received(:update_pull_request)
          .with(42, 'adjusted title', 'adjusted description')
      end
    end
  end

  describe '#update_status_from_pull_request_id'
end
