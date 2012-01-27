require 'bundler/gem_tasks'

task :default => [:spec, :cucumber]

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'cucumber/rake/task'
namespace :cucumber do
  Cucumber::Rake::Task.new :strict do |task|
    task.cucumber_opts = '-p strict'
  end

  Cucumber::Rake::Task.new :wip do |task|
    task.cucumber_opts = '-p wip'
  end
end

desc 'Run all Cucumber features'
task :cucumber => ['cucumber:wip', 'cucumber:strict']
