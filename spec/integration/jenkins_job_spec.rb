require 'spec_helper'

describe JenkinsJob do
  describe "#save_job_status" do
    let(:status) { JobStatus.new('name' => 'job-123') }

    context "when a job with that number doesn't exist" do
      it "saves the job" do
        JenkinsJob.save_job_status(status)
        expect(JenkinsJob.get_job_status(123)).to eq status
      end
    end

    context "when a job with that number does exist" do
      before { JenkinsJob.save_job_status(JobStatus.new('name' => 'XXX-123')) }
      it "upserts the job" do
        JenkinsJob.save_job_status(status)
        expect(JenkinsJob.get_job_status(123)).to eq status
      end

      it "doesn't create a new job" do
        expect(JenkinsJob.count).to eq 1
      end
    end
  end

  describe "#get_job_status" do
    context "when a job with that number doesn't exist" do
      subject { JenkinsJob.get_job_status(123) }
      it { should be nil }
    end
  end
end
