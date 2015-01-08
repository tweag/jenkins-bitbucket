RSpec.configure do |config|
  config.order = 'random'

  config.before do
    suppress_warnings { IMAGE_REQUIRED = nil }
  end
end

module Kernel
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    result
  end
end
