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

  attr_writer :embedded_data

  def embedded_data
    @embedded_data ||= default_embedded_data.merge(
      EmbeddedData.load(description)
    )
  end

  private

  def default_embedded_data
    { 'automerge?' => false }
  end
end
