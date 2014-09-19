module MarkdownHelper
  def md_link_to(text, url)
    "[#{text}](#{url})"
  end

  def md_image(*args)
    '!' + md_link_to(*args)
  end

  def quote(text)
    text.gsub(/^/, '> ').html_safe
  end
end
