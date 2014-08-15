class PullRequest < Hashie::Mash
  def identifier
    Util.extract_id(title)
  end

  def sha
    source.commit['hash']
  end

  def url
    links.html.href
  end
end
