describe JobStatusInteractor do
  describe '.call' do
    subject { described_class.new(jenkins: job_store, bitbucket: bitbucket) }

    let(:bitbucket) { double update_status: nil }
    let(:params)    { double }
    let(:job)       { double }
    let(:job_store) { double }

    before do
      allow(job_store).to receive(:new_from_jenkins).with(params) { job }

      allow(job_store).to receive(:store).with(job) { stored? }

      subject.call(params)
    end

    context 'the job store stores the job' do
      let(:stored?) { true }

      it 'stores the job' do
        expect(job_store).to have_received(:store)
      end

      it 'updates the status message of the pull request' do
        expect(bitbucket).to have_received(:update_status).with(job)
      end
    end

    context 'the job store does not store the job' do
      let(:stored?) { false }

      it 'attempts to store job' do
        expect(job_store).to have_received(:store)
      end

      it 'does not update the status message of the pull request' do
        expect(bitbucket).to_not have_received(:update_status)
      end
    end
  end
end
