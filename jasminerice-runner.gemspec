# -*- encoding: utf-8 -*-
require 'date'
require File.expand_path('../lib/jasminerice-runner/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name        = "jasminerice-runner"
  spec.version     = Jasminerice::Runner.gem_version
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Chris Nelson', 'Rada Bogdan Raul']
  spec.email       = ["chris@gaslightsoftware.com", 'raoul_ice@yahoo.com']
  spec.homepage    = ''
  spec.summary     = %q{runs jasmine specs using capybara}
  spec.description = %q{Adds a rake task to run jasmine specs using capybara}
  spec.date = Date.today
  spec.licenses = ['MIT']
  spec.rubyforge_project = 'jasminerice-runner'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = spec.files.grep(/^(spec)/)
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0'
  spec.required_rubygems_version = '>= 2.4'
  spec.metadata = {
    'source_code' => spec.homepage,
    'bug_tracker' => "#{spec.homepage}/issues"
  }
  # specify any dependencies here; for example:
  # spec.add_development_dependency "rspec"
  spec.add_runtime_dependency 'capybara',  '>= 1.0', '>= 1.0'
  spec.add_runtime_dependency 'jasminerice', '>= 0.0', '>= 0.0.10'
  spec.add_runtime_dependency 'jasmine', '>= 1.1', '>= 1.1'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6', '>= 1.6'
  spec.add_runtime_dependency 'colorize', '~> 0.7', '>= 0.7'
  spec.add_runtime_dependency 'coffee-script', '>= 2.0', '>= 2.0'

  spec.add_development_dependency 'appraisal', '~> 2.1', '>= 2.1'
  spec.add_development_dependency 'rspec', '~> 3.4', '>= 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.11', '>= 0.10'
  spec.add_development_dependency 'simplecov-summary', '~> 0.0.4', '>= 0.0.4'
  spec.add_development_dependency 'rake', '~> 11.0', '>= 11.0'

end
