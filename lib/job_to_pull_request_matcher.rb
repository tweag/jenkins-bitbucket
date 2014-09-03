module JobToPullRequestMatcher
  def self.normalize_identifier(identifier)
    identifier && identifier.gsub(/[^a-zA-Z0-9]/, '')
  end
end
