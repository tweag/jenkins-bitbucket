class PullRequest < Hashie::Mash
  def branch
    source['branch'].name
  end

  def identifier
    JobToPullRequestMatcher.normalize_identifier(branch)
  end

  def sha
    Util.normalize_sha(source.commit['hash'])
  end

  def url
    links.html.href
  end
end
