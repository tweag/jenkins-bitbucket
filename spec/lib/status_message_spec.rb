require 'spec_helper'

describe StatusMessage do
  subject(:status_message) { described_class.new(pull_request, job) }

  let(:pull_request) { double }
  let(:job)          { double }

  describe '#status' do
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
end
