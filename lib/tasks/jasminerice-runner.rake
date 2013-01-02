namespace :jasminerice do

  desc "run jasmine specs in jasmine rice"
  task :run, [:jasmine_environment] => :environment do |t, args|
    require "capybara/rails"
    require "jasminerice-runner/runner"
    args.with_defaults(jasmine_environment: nil)
    Jasminerice::Runner.new.run(args[:jasmine_environment])
  end
end
