require 'bitbucket_client'

BitbucketClient.tap do |config|
  config.user     = ENV.fetch('BIT_BUCKET_USER')
  config.password = ENV.fetch('BIT_BUCKET_PASSWORD')
  config.repo     = ENV.fetch('BIT_BUCKET_REPO')
end
