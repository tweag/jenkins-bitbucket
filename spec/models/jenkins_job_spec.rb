describe JenkinsJob, type: :model do
  subject { described_class.new_from_jenkins(params) }

  let(:params) do
    {
      'name'  => 'the-name-123',
      'url'   => 'job/test-job-for-webhooks/',
      'build' =>
      {
        'full_url' => 'http://example.com/the-full-url',
        'number'   => 3,
        'phase'    => 'the-phase',
        'status'   => 'the-status',
        'url'      => 'job/test-job-for-webhooks/3/',
        'scm'      =>
        {
          'url'    => 'git@bitbucket.org:mountdiablo/ce_bacchus.git',
          'branch' => 'origin/my-branch/STORY-123',
          'commit' => '9a6e22c90bb0c90781dcf6f4ff94b52f97d80883'
        },
        'artifacts'  => {}
      }
    }
  end

  its(:name)       { is_expected.to eq 'the-name-123' }
  its(:branch)     { is_expected.to eq 'my-branch/STORY-123' }
  its(:phase)      { is_expected.to eq 'the-phase' }
  its(:status)     { is_expected.to eq 'the-status' }
  its(:url)        { is_expected.to eq 'http://example.com/the-full-url' }
  its(:as_json)    { is_expected.to eq params }
  its(:sha)        { is_expected.to eq '9a6e22c' }
  its(:identifier) { is_expected.to eq 'mybranchSTORY123' }

  context 'when it has no branch' do
    before { params['build']['scm'].delete('branch') }
    its(:identifier) { is_expected.to eq 'thename123' }
  end

  context 'when it has no status' do
    let(:params) do
      JenkinsJobExample.attributes.tap do |attrs|
        attrs['build'].delete('status')
      end
    end

    its(:status) { is_expected.to be nil }
  end

  describe '#build_status' do
    context 'when the job has a status' do
      subject do
        JenkinsJobExample.build('build' => { 'status' => 'the-status' })
      end
      its(:build_status) { is_expected.to eq 'the-status' }
    end

    context 'when the job has no status' do
      subject do
        JenkinsJobExample.build(
          'build' => { 'status' => nil, 'phase' => 'the-phase' })
      end
      its(:build_status) { is_expected.to eq 'the-phase' }
    end
  end
end
