class Configuration
  extend ResettableSingleton
  include Virtus.model

  attribute :image_required, Boolean, default: false
  attribute :story_number_regexp, Regexp, default: '\d+'
  attribute :story_number_example, String, default: '123'

  def story_number_checker
    Regexp.new(story_number_regexp)
  end

  def self.from_env(env)
    options = {}
    env.each do |key, value|
      options[key.downcase.to_sym] = value
    end
    new(options)
  end
end
