require 'spec_helper'

describe PullRequestMessageAdjuster do
  let(:message_adjuster) do
    described_class.new(
      separator:      'xxx',
      renderer:       proc { |message| message.job.name },
      title_adjuster: proc do |message|
        "ADJUSTED #{message.pull_request.title}"
      end
    )
  end

  describe '#call' do
    subject { message_adjuster.call(StatusMessage.new(pull_request, job)) }

    let(:job) { JenkinsJobExample.build('name' => 'THE-JOB-NAME') }

    let(:pull_request) do
      double(title: 'original title', description: original_description)
    end

    let(:original_description) { '' }

    its([:title]) { is_expected.to eq 'ADJUSTED original title' }

    context 'when a status is not already in the message' do
      let(:original_description) { 'my pull request' }
      its([:description]) do
        is_expected.to eq "my pull request\nxxx\nTHE-JOB-NAME"
      end
    end

    context 'when a status is already in the message' do
      let(:original_description) { "my pull request\nxxx\nOLD STATUS" }

      its([:description]) do
        is_expected.to eq "my pull request\nxxx\nTHE-JOB-NAME"
      end
    end
  end
end
