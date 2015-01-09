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
    new(downcase_hash_keys(env))
  end

  def self.downcase_hash_keys(hash)
    hash.each_with_object({}) do |(key, value), new_hash|
      new_hash[key.downcase] = value
    end
  end
end
