module TimeHelper
  def ago(time)
    "(#{distance_of_time_in_words(time, Time.now)} ago)"
  end
end
