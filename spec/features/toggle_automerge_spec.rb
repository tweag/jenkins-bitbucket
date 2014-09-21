feature 'Toggling the automerge flag', vcr: true do
  before { decline_all_pull_requests }

  let!(:pull_request) do
    reset_pull_request.tap do |pr|
      visit bitbucket_refresh_path(pr.id)
      click_on 'Submit'
    end
  end

  let(:turn_on_url)  { bitbucket_automerge_path(pull_request.id, turn: :on) }
  let(:turn_off_url) { bitbucket_automerge_path(pull_request.id, turn: :off) }

  def reloaded_desciption
    reload_pull_request(pull_request).description
  end

  scenario 'a pull request not set to automerge' do
    expect(reloaded_desciption).to include turn_on_url
    visit turn_on_url
    click_on 'Submit'

    expect(reloaded_desciption).to include turn_off_url
    visit turn_off_url
    click_on 'Submit'

    expect(reloaded_desciption).to include turn_on_url
  end
end
