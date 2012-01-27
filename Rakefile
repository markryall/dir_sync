require 'bundler/gem_tasks'

task :default => :test
task :test => [:spec, :features]

task :spec do
  sh 'rspec spec'
end

task :features do
  sh 'cucumber'
end