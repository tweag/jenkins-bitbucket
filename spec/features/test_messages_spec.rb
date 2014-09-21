describe 'Testing messages', type: :feature do
  it 'does not blow up' do
    visit message_examples_path
    expect(page).to have_text 'Message Examples'
  end
end
