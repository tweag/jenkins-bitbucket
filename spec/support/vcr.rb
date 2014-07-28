require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/support/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { record: :new_episodes }
  c.configure_rspec_metadata!
end
