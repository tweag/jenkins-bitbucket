describe MarkdownHelper do
  let(:helper) { Object.new.extend(described_class) }

  describe '#code' do
    let(:text) { "AA\nBB\n\nCC" }

    it 'prepends each line with 4 spaces' do
      expect(helper.code(text)).to eq "    AA\n    BB\n    \n    CC"
    end

    it 'marks it as html_safe' do
      expect(helper.code(text)).to be_html_safe
    end
  end
end
