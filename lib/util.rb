module Util
  def self.normalize_sha(str)
    str.try(:[], 0, 7)
  end
end
