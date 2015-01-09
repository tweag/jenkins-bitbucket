module ResettableSingleton
  def instance
    @instance ||= new
  end

  def instance=(object)
    @instance = object
  end

  def reset!
    @instance = nil
  end
end
