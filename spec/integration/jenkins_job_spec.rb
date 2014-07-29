require 'spec_helper'

describe JenkinsJob do
  describe '.store' do
    let(:job) { JenkinsJobExample.build('name' => 'job-123') }

    context "when a job with that number doesn't exist" do
      it 'saves the job' do
        described_class.store(job)
        expect(described_class.fetch(123)).to eq job
      end
    end

    context 'when a job with that number does exist' do
      before { described_class.store(JenkinsJobExample.build('name' => 'XXX-123')) }
      it 'upserts the job' do
        described_class.store(job)
        expect(described_class.fetch(123)).to eq job
      end

      it "doesn't create a new job" do
        expect(described_class.count).to eq 1
      end
    end
  end

  describe '.fetch' do
    context "when a job with that number doesn't exist" do
      subject { described_class.fetch(123) }
      it { should be nil }
    end
  end
end
