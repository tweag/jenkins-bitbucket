class TestsController < ApplicationController
  def show
    @pull_requests = bitbucket_client.pull_requests.map do |pull_request|
      [pull_request, JenkinsJob[pull_request.identifier]]
    end
  end

  # rubocop:disable Style/MethodLength
  def messages
    pull_request_title = "My PR #{STORY_NUMBER_EXAMPLE}"

    job_and_pull_request_data = {
      'No job' => [
        'PR 123', nil
      ],
      'Job running' => [
        'PR 123', {
          'build' => {
            'phase' => 'STARTED', 'status' => nil
          } }
      ],
      'Job passed' => [
        'PR 123', {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'SUCCESS'
          } }
      ],
      'Job passed, but SHAs do not match' => [
        'PR 123', { 'build' => {
          'phase' => 'FINALIZED',
          'status' => 'SUCCESS',
          'scm' => { 'commit' => 'differentsha' }
        } }
      ],
      'Job failed' => [
        'PR 123', {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'FAILURE'
          } }
      ],
      'Job failed, but SHAs do not match' => [
        'PR 123', {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'FAILURE',
            'scm' => { 'commit' => 'differentsha' }
          } }
      ],
      'No story number in title' => [
        'PR no story number', {}
      ]
    }
    @messages = job_and_pull_request_data.map do |example_name, data|
      pull_request_title, job_attrs = *data
      pull_request = PullRequestExample.build('title' => pull_request_title)
      job = JenkinsJobExample.build(job_attrs) if job_attrs

      status_message = status_message_renderer.call(pull_request, job)
      [example_name, status_message]
    end
  end
  # rubocop:enable Style/MethodLength
end
