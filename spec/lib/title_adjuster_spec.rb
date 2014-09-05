require 'spec_helper'

describe TitleAdjuster do
  subject { title_adjuster.call(message) }

  let(:title_adjuster) { described_class.new(good: 'GOOD', bad: 'BAD') }

  let(:message) do
    double(
      StatusMessage,
      ready_to_review?: ready_to_review?,
      pull_request:     double(PullRequest, title: title)
    )
  end

  context 'when the pull request is ready to review' do
    let(:ready_to_review?) { true }

    context 'when the title already contains the same status' do
      let(:title) { 'GOOD pull request' }
      it { is_expected.to eq 'GOOD pull request' }
    end

    context 'when the title already contains the a different status' do
      let(:title) { 'BAD pull request' }
      it { is_expected.to eq 'GOOD pull request' }
    end

    context 'when the title does not contain a status' do
      let(:title) { 'pull request' }
      it { is_expected.to eq 'GOOD pull request' }
    end
  end

  context 'when the pull request is not ready to review' do
    let(:ready_to_review?) { false }

    context 'when the title already contains the same status' do
      let(:title) { 'BAD pull request' }
      it { is_expected.to eq 'BAD pull request' }
    end

    context 'when the title already contains the a different status' do
      let(:title) { 'GOOD pull request' }
      it { is_expected.to eq 'BAD pull request' }
    end

    context 'when the title does not contain a status' do
      let(:title) { 'pull request' }
      it { is_expected.to eq 'BAD pull request' }
    end
  end
end
