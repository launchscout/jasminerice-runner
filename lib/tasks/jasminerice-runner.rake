namespace :jasminerice do
  
  desc "run jasmine specs in jasmine rice"
  task :run => :environment do
    require "capybara/rails"
    require "jasminerice-runner/runner"
    Jasminerice::Runner.new.run
  end
end