describe MarkdownHelper do
  let(:helper) { Object.new.extend(described_class) }

  describe '#commit' do
    let(:text) { "Title\n\nBody\nBody 2" }

    it 'prepends each line with 4 spaces' do
      expect(helper.commit(text)).to eq "> ### Title\n> \n> Body\n> Body 2"
    end

    it 'marks it as html_safe' do
      expect(helper.commit(text)).to be_html_safe
    end
  end
end
