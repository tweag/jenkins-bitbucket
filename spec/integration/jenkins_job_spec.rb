require 'spec_helper'

describe JenkinsJob do
  describe '.store' do
    let(:job) { JenkinsJobExample.build('name' => 'job-123') }

    context "when a job with that number doesn't exist" do
      it 'saves the job' do
        described_class.store(job)
        expect(described_class[123]).to eq job
      end

      it 'returns true' do
        expect(described_class.store(job)).to be true
      end
    end

    context 'when a job with that number does exist' do
      before do
        described_class.store(JenkinsJobExample.build('name' => 'XXX-123'))
      end

      it 'upserts the job' do
        described_class.store(job)
        expect(described_class[123]).to eq job
      end

      it "doesn't create a new job" do
        expect(described_class.count).to eq 1
      end

      it 'returns true' do
        expect(described_class.store(job)).to be true
      end
    end

    context 'when the job does not have a number' do
      let(:job) { JenkinsJobExample.build('name' => 'job-no-number') }

      it 'does nothing' do
        described_class.store(job)
        expect(described_class.count).to eq 0
      end

      it 'returns false' do
        expect(described_class.store(job)).to be_false
      end
    end
  end

  describe '.[]' do
    context "when a job with that number doesn't exist" do
      subject { described_class[123] }

      it { should be nil }
    end

    context 'when given nil' do
      subject { described_class[nil] }

      before { described_class.store(job) }
      let(:job) { JenkinsJobExample.build('name' => 'no-story-number') }

      it { should be nil }
    end
  end
end
