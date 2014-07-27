require 'bit_bucket_client'

BitBucketClient.tap do |config|
  config.user     = ENV['BIT_BUCKET_USER']
  config.password = ENV['BIT_BUCKET_PASSWORD']
  config.repo     = ENV['BIT_BUCKET_REPO']
end
