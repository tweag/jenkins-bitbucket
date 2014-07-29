require 'spec_helper'

describe 'Testing messages' do
  it 'does not blow up' do
    get '/test/messages'
  end
end
