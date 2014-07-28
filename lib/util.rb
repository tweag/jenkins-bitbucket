module Util
  def self.extract_id(str)
    str.split(/\D/).last.try(:to_i)
  end
end
