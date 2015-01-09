RSpec.configure do |config|
  config.order = 'random'

  config.before do
    Configuration.reset!
  end
end
