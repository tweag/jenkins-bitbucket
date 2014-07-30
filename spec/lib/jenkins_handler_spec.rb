require 'spec_helper'
require 'jenkins_handler'

describe JenkinsHandler do
  describe '.call' do
    subject { described_class.new(jenkins: jenkins, bitbucket: bitbucket) }

    let(:params) { double }

    let(:jenkins)   { double store: nil }
    let(:bitbucket) { double update_status: nil }
    let(:job)       { double }

    before do
      allow(jenkins).to receive(:new_from_jenkins).with(params).and_return(job)

      subject.call(params)
    end

    describe 'a job started' do
      it 'upserts the job' do
        expect(jenkins).to have_received(:store).with(job)
      end

      it 'add the update_status on bitbuket' do
        expect(bitbucket).to have_received(:update_status).with(job)
      end
    end
  end
end
