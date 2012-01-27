require 'bundler/gem_tasks'

task :default => :test
task :test => [:spec, :features]

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :features do
  sh 'cucumber'
end
