require 'spec_helper'

describe PullRequestAdjuster do
  subject do
    described_class.new(client,
                        message_adjuster: message_adjuster,
                        job_store:        job_store
                       )
  end

  let(:message_adjuster) { double }
  let(:pull_requests) {}
  let(:job_store) { {} }

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
    let(:story_id) { 123 }
    let(:job) { JenkinsJobExample.build('name' => "job-name-#{story_id}") }

    context 'when a pull request exists for the story' do
      let(:pull_request) do
        double(
          id:           42,
          story_number: story_id,
          description:  'this is my pull request'
        )
      end

      let(:pull_requests) do
        [
          double(id: 1, story_number: 911),
          pull_request,
          double(id: 3, story_number: 666)
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
          double(id: 1, story_number: 12),
          double(id: 3, story_number: 234)
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
    let(:pull_request) { double(id: 42, story_number: 123) }
    let(:job_store) { { 123 => job } }

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

    context 'when the pull request has no story number' do
      let(:pull_request) { double(id: 42, story_number: nil) }
      let(:job) {}

      it 'updates the status of the pull request' do
        subject.update_status_from_pull_request pull_request

        expect(client).to have_received(:update_pull_request)
          .with(42, 'adjusted title', 'adjusted description')
      end
    end
  end

  describe '#update_status_from_pull_request_id'
end
