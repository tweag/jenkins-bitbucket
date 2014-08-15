class PullRequest < Hashie::Mash
  def identifier
    source.branch.name
  end

  def sha
    source.commit['hash']
  end

  def url
    links.html.href
  end
end
