describe PullRequest, type: :model do
  subject { described_class.new(PullRequestExample.attributes(attrs)) }

  let(:attrs) do
    {
      'source' => {
        'commit' => { 'hash' => 'abcdefghijkl' },
        'branch' => { 'name' => 'my-branch/STORY-123' }
      },
      'links' => { 'html' => { 'href' => 'http://pullrequest.com' } }
    }
  end

  its(:branch)        { is_expected.to eq 'my-branch/STORY-123' }
  its(:identifier)    { is_expected.to eq 'mybranchSTORY123' }
  its(:sha)           { is_expected.to eq 'abcdefg' }
  its(:url)           { is_expected.to eq 'http://pullrequest.com' }

  context 'no embedded data' do
    let(:attrs) do
      { 'description' => '[data]: {"the":"info"}' }
    end

    its(:embedded_data) { is_expected.to include 'automerge?' => false }
  end

  context 'embedded data' do
    let(:attrs) do
      { 'description' => '[data]: {"automerge?":true}' }
    end

    its(:embedded_data) { is_expected.to include 'automerge?' => true }
  end
end
