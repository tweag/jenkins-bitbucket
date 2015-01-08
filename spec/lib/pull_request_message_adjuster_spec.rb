describe PullRequestMessageAdjuster do
  let(:message_adjuster) do
    described_class.new(
      separator:      'xxx',
      renderer:       renderer,
      title_adjuster: proc do |message|
        "ADJUSTED #{message.pull_request.title}"
      end
    )
  end
  let(:renderer) { proc { |message| message.job.name } }

  describe '#call' do
    subject(:adjusted_message) do
      status_message = StatusMessage.new(pull_request,
                                         job,
                                         [],
                                         original_description)
      message_adjuster.call(status_message)
    end

    let(:job) { JenkinsJobExample.build('name' => 'THE-JOB-NAME') }

    let(:pull_request) do
      PullRequest.new(title: 'original title')
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

    context "when the pull request's description already contains a status" do
      let(:renderer) { double(:renderer, call: 'new description') }
      let(:original_description) { 'original descriptionxxxSTATUS' }

      it 'strips existing status message' do
        expect(renderer).to receive(:call) do |status_message|
          expect(status_message.pull_request.description)
            .to eq 'original description'
        end

        adjusted_message
      end
    end
  end
end
