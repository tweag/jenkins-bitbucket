require 'spec_helper'

describe JobStatusInteractor do
  describe '.call' do
    subject { described_class.new(jenkins: jenkins, bitbucket: bitbucket) }

    let(:bitbucket) { double update_status: nil }
    let(:params) { double }
    let(:job) { double }

    before do
      allow(jenkins).to receive(:new_from_jenkins).with(params).and_return(job)

      subject.call(params)
    end

    context 'the job store stores the job' do
      let(:jenkins)   { double store: true }

      it 'stores the job' do
        expect(jenkins).to have_received(:store).with(job)
      end

      it 'updates the status message of the pull request' do
        expect(bitbucket).to have_received(:update_status).with(job)
      end
    end

    context 'the job store does not store the job' do
      let(:jenkins)   { double store: nil }

      it 'attempts to store job' do
        expect(jenkins).to have_received(:store).with(job)
      end

      it 'does not update the status message of the pull request' do
        expect(bitbucket).to_not have_received(:update_status)
      end
    end
  end
end
