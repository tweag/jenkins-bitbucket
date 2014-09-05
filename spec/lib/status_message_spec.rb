require 'spec_helper'

describe StatusMessage do
  subject(:status_message) { described_class.new(pull_request, job) }

  let(:pull_request) { double }
  let(:job)          { double }

  describe '#status' do
    context 'when there is no job' do
      let(:job) { nil }
      its(:status) { is_expected.to be nil }
    end

    context 'when the job has a status' do
      let(:job) { double(status: 'the-status') }
      its(:status) { is_expected.to eq 'the-status' }
    end

    context 'when the job has no status' do
      let(:job) { double(status: nil, phase: 'the-phase') }
      its(:status) { is_expected.to eq 'the-phase' }
    end
  end

  describe '#title_contains_story_number?' do
    subject { status_message.title_contains_story_number?(/\d/) }

    context 'when the title contains a story number' do
      let(:pull_request) { double(title: 'a1') }
      it { is_expected.to be true }
    end

    context 'when the title does not contain a story number' do
      let(:pull_request) { double(title: 'a') }
      it { is_expected.to be false }
    end
  end

  describe '#shas_match?' do
    subject { status_message.shas_match? }

    context 'when the shas match' do
      let(:pull_request) { double(sha: 'a') }
      let(:job)          { double(sha: 'a') }

      it { is_expected.to be true }
    end

    context 'when the shas do not match' do
      let(:pull_request) { double(sha: 'a') }
      let(:job)          { double(sha: 'z') }

      it { is_expected.to be false }
    end
  end

  describe '#ready_to_review?' do
    let(:job) { double(JenkinsJob, status: job_status, sha: job_sha) }
    let(:pull_request) do
      double(PullRequest, title: pull_request_title, sha: pull_request_sha)
    end

    let(:pull_request_title) { 'a1' }
    let(:pull_request_sha)   { 'a' }
    let(:job_status)         { 'PASSING' }
    let(:job_sha)            { 'a' }

    context 'when all is well' do
      it { is_expected.to be_ready_to_review }
    end

    context 'when the job is not passing' do
      let(:job_status) { 'ABORTED' }
      it { is_expected.to_not be_ready_to_review }
    end

    context 'when the shas do not match' do
      let(:job_sha) { 'z' }
      it { is_expected.to_not be_ready_to_review }
    end

    context 'when the title does not contain a story number' do
      let(:pull_request_title) { 'a' }
      it { is_expected.to_not be_ready_to_review }
    end
  end
end
