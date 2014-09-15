describe TitleAdjuster do
  subject { title_adjuster.call(message) }

  let(:title_adjuster) do
    described_class.new(good: 'GOOD', bad: 'BAD', running: 'RUNNING')
  end

  let(:message) do
    double(
      StatusMessage,
      ready_to_review?:                    ready_to_review?,
      ready_to_review_assuming_it_passes?: ready_to_review_assuming_it_passes?,
      pull_request:                        double(PullRequest, title: title)
    )
  end

  context 'when the pull request is ready to review' do
    let(:ready_to_review?) { true }
    let(:ready_to_review_assuming_it_passes?) { true }

    context 'when the title already contains the same status' do
      let(:title) { 'GOOD pull request' }
      it { is_expected.to eq 'GOOD pull request' }
    end

    context 'when the title already contains the a different status' do
      let(:title) { 'BAD pull request' }
      it { is_expected.to eq 'GOOD pull request' }
    end

    context 'when the title does not contain a status' do
      let(:title) { 'pull request' }
      it { is_expected.to eq 'GOOD pull request' }
    end
  end

  context 'when the pull request is not ready to review' do
    let(:ready_to_review?) { false }
    let(:ready_to_review_assuming_it_passes?) { false }

    context 'when the title already contains the same status' do
      let(:title) { 'BAD pull request' }
      it { is_expected.to eq 'BAD pull request' }
    end

    context 'when the title already contains the a different status' do
      let(:title) { 'GOOD pull request' }
      it { is_expected.to eq 'BAD pull request' }
    end

    context 'when the title does not contain a status' do
      let(:title) { 'pull request' }
      it { is_expected.to eq 'BAD pull request' }
    end
  end

  context 'when the pull request is running, but otherwise ready to review,' \
    'assuming it passes' do

    let(:ready_to_review?) { false }
    let(:ready_to_review_assuming_it_passes?) { true }

    context 'when the title already contains the same status' do
      let(:title) { 'RUNNING pull request' }
      it { is_expected.to eq 'RUNNING pull request' }
    end

    context 'when the title already contains the a different status' do
      let(:title) { 'GOOD pull request' }
      it { is_expected.to eq 'RUNNING pull request' }
    end

    context 'when the title does not contain a status' do
      let(:title) { 'pull request' }
      it { is_expected.to eq 'RUNNING pull request' }
    end
  end
end
