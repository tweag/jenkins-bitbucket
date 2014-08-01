require 'spec_helper'

describe PullRequestMessageAdjuster do
  let(:message_adjuster) do
    described_class.new(
      separator: 'xxx',
      renderer:  proc { |_pull_request, job| job.name }
    )
  end

  describe '#call' do
    subject { message_adjuster.call(pull_request, job) }

    let(:job) { JenkinsJobExample.build('name' => 'THE-JOB-NAME') }

    let(:pull_request) do
      double(title: 'original title', description: original_description)
    end

    context 'when a status is not already in the message' do
      let(:original_description) { 'my pull request' }

      describe '[:title]' do
        subject { super()[:title] }
        it { is_expected.to eq 'original title' }
      end

      describe '[:description]' do
        subject { super()[:description] }
        it { is_expected.to eq "my pull request\nxxx\nTHE-JOB-NAME" }
      end
    end

    context 'when a status is already in the message' do
      let(:original_description) { "my pull request\nxxx\nOLD STATUS" }

      describe '[:title]' do
        subject { super()[:title] }
        it { is_expected.to eq 'original title' }
      end

      describe '[:description]' do
        subject { super()[:description] }
        it { is_expected.to eq "my pull request\nxxx\nTHE-JOB-NAME" }
      end
    end
  end
end
