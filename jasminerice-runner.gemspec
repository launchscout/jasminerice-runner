# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jasminerice-runner/version"

Gem::Specification.new do |s|
  s.name        = "jasminerice-runner"
  s.version     = Jasminerice::Runner::VERSION
  s.authors     = ["Chris Nelson"]
  s.email       = ["chris@gaslightsoftware.com"]
  s.homepage    = ""
  s.summary     = %q{runs jasmine specs using capybara}
  s.description = %q{Adds a rake task to run jasmine specs using capybara}

  s.rubyforge_project = "jasminerice-runner"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "capybara"
end
