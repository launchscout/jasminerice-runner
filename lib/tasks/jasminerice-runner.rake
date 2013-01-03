namespace :jasminerice do

  desc "run jasmine specs in jasmine rice"
  task :run, [:jasmine_environment] => :environment do |t, args|
    require "capybara/rails"
    require "jasminerice-runner/runner"
    runner = Jasminerice::Runner.new(args[:jasmine_environment])
    runner.run
  end
end
