module MarkdownHelper
  def md_link_to(text, url)
    "[#{text}](#{url})"
  end

  def refresh_link(pull_request)
    md_link_to 'refresh this message',
               "#{root_url}/bitbucket/refresh/#{pull_request.id}"
  end
end
