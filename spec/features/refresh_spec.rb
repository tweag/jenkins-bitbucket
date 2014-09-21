feature "Refreshing a pull request's status message", vcr: true do
  before { decline_all_pull_requests }

  let(:pull_request)        { reset_pull_request }
  let(:refresh_url)         { bitbucket_refresh_path(pull_request.id) }
  let(:updated_description) { reload_pull_request(pull_request).description }

  scenario 'a pull request with no status message' do
    update_pull_request_description pull_request, 'XXX'

    visit refresh_url
    click_on 'Submit'

    expect(updated_description).to include '* * *'
    expect(updated_description).to include refresh_url
  end
end
