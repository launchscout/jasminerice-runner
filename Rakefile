require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  default_options = ['--colour']
  default_options.concat(['--backtrace', '--fail-fast']) if ENV['DEBUG']
  spec.rspec_opts = default_options
  spec.verbose = true
end

desc 'Default: run the unit tests.'
task default: [:all]

desc 'Test the plugin under all supported Rails versions.'
task :all do |_t|
  if ENV['TRAVIS']
      exec(' bundle exec appraisal install && bundle exec rake appraisal spec')
  else
    exec('bundle exec appraisal install && bundle exec rake appraisal spec')
  end
end
