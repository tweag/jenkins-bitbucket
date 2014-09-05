describe 'Testing messages', type: :request do
  it 'does not blow up' do
    get message_examples_path
  end
end
