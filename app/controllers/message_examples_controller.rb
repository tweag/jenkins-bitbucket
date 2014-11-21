class MessageExamplesController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def index
    job_and_pull_request_data = {
      'No job' => {
      },
      'Job running' => {
        job: {
          'build' => {
            'phase' => 'STARTED', 'status' => nil
          }
        }
      },
      'Job passed' => {
        pull_request: {
          'title' => 'PR 123',
          'source' => {
            'branch' => { 'name' => "story/#{STORY_NUMBER_EXAMPLE}" }
          }
        },
        job:          {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'SUCCESS'
          }
        }
      },
      'Job passed, but SHAs do not match' => {
        job: {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'SUCCESS',
            'scm' => { 'commit' => 'differentsha' }
          }
        }
      },
      'Job failed' => {
        job: {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'FAILURE'
          }
        }
      },
      'Job failed, but SHAs do not match' => {
        job: {
          'build' => {
            'phase' => 'FINALIZED',
            'status' => 'FAILURE',
            'scm' => { 'commit' => 'differentsha' }
          }
        }
      },
      'No story number in title' => {
        pull_request: { 'title' => 'PR no story number' },
        job:          {}
      },
      'Wip commits' => {
        job:     {},
        commits: [{ 'message' => 'WIP commit' }]
      },
      'Automerge on' => {
        ebedded_data: { 'automerge?' => true }
      }
    }
    @messages = job_and_pull_request_data
                .map do |example_name, example|

      pull_request_attrs = example[:pull_request] || { 'title' => 'PR 123' }

      commits = example[:commits] ||
                [{
                  'message' => "Some commit\n\n& this is the body\nThis is it"
                }]

      pull_request = PullRequestExample.build(pull_request_attrs)
      if example[:ebedded_data]
        pull_request.embedded_data = example[:ebedded_data]
      end

      job = JenkinsJobExample.build(example[:job]) if example[:job]

      status_message = StatusMessage.new(pull_request, job, commits)
      adjusted_pull_request = message_adjuster.call(status_message)
      [example_name, adjusted_pull_request]
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
