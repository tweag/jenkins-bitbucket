# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

if Rails.env.test? || Rails.env.development?
  require 'rubocop/rake_task'
  task default: [:rubocop]

  desc 'Run RuboCop'
  RuboCop::RakeTask.new(:rubocop)
end
