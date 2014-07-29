class JenkinsJobExample
  # rubocop:disable Style/MethodLength
  def self.attributes(attrs = {})
    {
      'name'  => 'test-job-for-webhooks-123',
      'url'   => 'job/test-job-for-webhooks/',
      'build' => {
        'full_url' => 'http://www.example.com/job/test-job-for-webhooks',
        'number'   => 3,
        'phase'    => 'FINALIZED',
        'status'   => 'SUCCESS',
        'url'      => 'job/test-job-for-webhooks/3/',
        'scm'      => {
          'url'    => 'git@bitbucket.org:mountdiablo/ce_bacchus.git',
          'branch' => 'origin/master',
          'commit' => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        },
        'artifacts'  => {}
      }
    }.deep_merge(attrs)
  end
  # rubocop:enable Style/MethodLength

  def self.build(attrs)
    JenkinsJob.new_from_jenkins(attributes(attrs))
  end
end
