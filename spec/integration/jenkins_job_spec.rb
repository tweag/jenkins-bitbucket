require 'spec_helper'

describe JenkinsJob do
  describe ".save_job_status" do
    let(:status) { build_job('name' => 'job-123') }

    context "when a job with that number doesn't exist" do
      it "saves the job" do
        described_class.save_job_status(status)
        expect(described_class.get_job_status(123)).to eq status
      end
    end

    context "when a job with that number does exist" do
      before { described_class.save_job_status(build_job('name' => 'XXX-123')) }
      it "upserts the job" do
        described_class.save_job_status(status)
        expect(described_class.get_job_status(123)).to eq status
      end

      it "doesn't create a new job" do
        expect(described_class.count).to eq 1
      end
    end
  end

  describe ".get_job_status" do
    context "when a job with that number doesn't exist" do
      subject { described_class.get_job_status(123) }
      it { should be nil }
    end
  end
end
