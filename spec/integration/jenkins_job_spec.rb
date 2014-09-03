require 'spec_helper'

describe JenkinsJob, type: :request do
  describe '.store' do
    let(:job) do
      JenkinsJobExample.build(
        'build' => { 'scm' => { 'branch' => 'origin/my-branch' } }
      )
    end

    context "when a job with that identifier doesn't exist" do
      it 'saves the job' do
        described_class.store(job)
        expect(described_class['my-branch'].identifier).to eq 'mybranch'
      end

      it 'returns true' do
        expect(described_class.store(job)).to be true
      end
    end

    context 'when a job with that identifier does exist' do
      before do
        described_class.store(
          JenkinsJobExample.build(
            'build' => { 'scm' => { 'branch' => 'origin/my-branch' } }
          )
        )
      end

      it 'upserts the job' do
        described_class.store(job)
        expect(described_class['my-branch'].identifier).to eq 'mybranch'
      end

      it "doesn't create a new job" do
        described_class.store(job)
        expect(described_class.count).to eq 1
      end

      it 'returns true' do
        expect(described_class.store(job)).to be true
      end
    end
  end

  describe '.[]' do
    context "when a job with that identifier doesn't exist" do
      subject { described_class['my-branch'] }
      it { is_expected.to be nil }
    end

    context 'when given nil' do
      subject { described_class[nil] }
      it { is_expected.to be nil }
    end
  end
end
