module EmbeddedData
  def self.load(description)
    match = description[/^\[data\]: (\S+)/, 1]

    if match
      JSON.parse(URI.unescape(match))
    else
      {}
    end
  end

  def self.dump(data)
    "[data]: #{URI.escape(JSON.dump(data), ' ')}"
  end
end
