namespace :jasminerice do

  desc "run jasmine specs in jasmine rice"
  task :run, [:jasmine_environment] => :environment do |t, args|
    require "capybara/rails" if defined?(Rails)
    require "jasminerice-runner/worker"
    runner = Jasminerice::Runner::Worker.new(args[:jasmine_environment])
    runner.run
  end
end
