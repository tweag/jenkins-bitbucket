class Configuration
  attr_accessor :image_required

  def self.instance
    @instance ||= new
  end

  def self.reset!
    @instance = nil
  end
end
