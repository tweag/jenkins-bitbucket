# rubocop:disable Style/ClassLength
class PullRequestExample
  # rubocop:disable Style/MethodLength
  def self.attributes(attrs = {})
    {
      'description' => 'This is my pull request',
      'links' => {
        'decline' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211/decline'
        },
        'commits' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211/commits'
        },
        'self' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211'
        },
        'comments' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211/comments'
        },
        'merge' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211/merge'
        },
        'html' => {
          'href' => 'https://bitbucket.org/jenkins-bitbucket/jenkins-bitbucket/pull-request/211'
        },
        'activity' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211/activity'
        },
        'diff' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211/diff'
        },
        'approve' => {
          'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests/211/approve'
        }
      },
      'author' => {
        'username' => 'jenkins-bitbucket',
        'display_name' => 'jenkins-bitbucket jenkins-bitbucket',
        'links' => {
          'self' => {
            'href' => 'https://api.bitbucket.org/2.0/users/jenkins-bitbucket'
          },
          'avatar' => {
            'href' => 'https://secure.gravatar.com/avatar/d1de01807f6b367718a207845dfc8a64?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2Fdec446fd616d%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&s=32'
          }
        }
      },
      'close_source_branch' => false,
      'title' => 'My Pull Request PR-123',
      'destination' => {
        'commit' => {
          'hash' => 'bbbbbbbbbbbb',
          'links' => {
            'self' => {
              'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/commit/bbbbbbbbbbbb'
            }
          }
        },
        'repository' => {
          'links' => {
            'self' => {
              'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket'
            },
            'avatar' => {
              'href' => 'https://d3oaxc4q5k2d6q.cloudfront.net/m/dec446fd616d/img/language-avatars/default_16.png'
            }
          },
          'full_name' => 'jenkins-bitbucket/jenkins-bitbucket',
          'name' => 'jenkins-bitbucket'
        },
        'branch' => {
          'name' => 'master'
        }
      },
      'reason' => '',
      'closed_by' => nil,
      'source' => {
        'commit' => {
          'hash' => 'aaaaaaaaaaaa',
          'links' => {
            'self' => {
              'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/commit/aaaaaaaaaaaa'
            }
          }
        },
        'repository' => {
          'links' => {
            'self' => {
              'href' => 'https://api.bitbucket.org/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket'
            },
            'avatar' => {
              'href' => 'https://d3oaxc4q5k2d6q.cloudfront.net/m/dec446fd616d/img/language-avatars/default_16.png'
            }
          },
          'full_name' => 'jenkins-bitbucket/jenkins-bitbucket',
          'name' => 'jenkins-bitbucket'
        },
        'branch' => {
          'name' => 'my-branch'
        }
      },
      'state' => 'OPEN',
      'created_on' => '2014-07-29T00:59:26.973759+00:00',
      'updated_on' => '2014-07-29T00:59:29.265319+00:00',
      'merge_commit' => nil,
      'id' => 211
    }.deep_merge(attrs)
  end
  # rubocop:enable Style/MethodLength

  def self.build(attrs)
    PullRequest.new(attributes(attrs))
  end
end
