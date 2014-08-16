class PullRequest < Hashie::Mash
  def identifier
    source.branch.name
  end

  def sha
    Util.normalize_sha(source.commit['hash'])
  end

  def url
    links.html.href
  end
end
