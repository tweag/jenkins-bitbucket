class PullRequest < Hashie::Mash
  def story_number
    Util.extract_id(title)
  end

  def sha
    source.commit['hash']
  end
end
