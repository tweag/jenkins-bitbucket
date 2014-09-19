class MessageExamplesController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  def index
    job_and_pull_request_data = {
      'No job' => [
        { 'title' => 'PR 123' },
        nil
      ],
      'Job running' => [
        { 'title' => 'PR 123' },
        {
          'build' => {
            'phase' => 'STARTED', 'status' => nil
          }
        }
      ],
      'Job passed' => [
        {
          'title' => 'PR 123',
          'source' => {
            'branch' => { 'name' => "story/#{STORY_NUMBER_EXAMPLE}" }
          }
        },
        {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'SUCCESS'
          }
        }
      ],
      'Job passed, but SHAs do not match' => [
        { 'title' => 'PR 123' },
        {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'SUCCESS',
            'scm' => { 'commit' => 'differentsha' }
          }
        }
      ],
      'Job failed' => [
        { 'title' => 'PR 123' },
        {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'FAILURE'
          }
        }
      ],
      'Job failed, but SHAs do not match' => [
        { 'title' => 'PR 123' },
        {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'FAILURE',
            'scm' => { 'commit' => 'differentsha' }
          }
        }
      ],
      'No story number in title' => [
        { 'title' => 'PR no story number' },
        {}
      ],
      'Wip commits' => [
        { 'title' => 'PR 123' },
        {},
        [{ 'message' => 'WIP commit' }]
      ]
    }
    @messages = job_and_pull_request_data
      .map do |example_name, (pull_request_attrs, job_attrs, commits)|

      pull_request = PullRequestExample.build(pull_request_attrs)
      job = JenkinsJobExample.build(job_attrs) if job_attrs
      commits ||= [
        { 'message' => "Some commit\n\nAnd this is the body\nThis is it" }
      ]

      status_message = StatusMessage.new(pull_request, job, commits)
      adjusted_pull_request = message_adjuster.call(status_message)
      [example_name, adjusted_pull_request]
    end
  end
  # rubocop:enable Metrics/MethodLength
end
