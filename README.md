# Jenkins-Bitbucket

Keeps Bitbucket pull requests up-to-date with the related job status from Jenkins.

## How it works

The app listens for web hooks from Jenkins and Bitbucket.
When a Jenkins job it sends it's updated status to the app.
When a pull request is made, it alerts the app.
The app uses that info to update the description of the pull request with information about the matching job in Jenkins.

## Development

I'm pretty sure it's something like:

    bundle install
    rake db:setup
    rails server

In development, the configured to run against [this repository on Bitbucket](https://bitbucket.org/jenkins-bitbucket/jenkins-bitbucket/pull-requests).

If you need to test out the webhooks, a useful technique is to run the app on your local machine and use the [proxylocal gem](http://proxylocal.com/) to let Jenkins and Bitbucket talk to your local machine.
