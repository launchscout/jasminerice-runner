if defined?(Rails)
  class Jasminerice::Runner::Engine < Rails::Engine

    initializer "add assets to be precompiled" do |app|
      app.config.assets.precompile += %w(
        jasminerice_runner_base.js.coffee
        jasminerice_legacy_reporter.js.coffee
        jasminerice_reporter.js.coffee
      )
    end

    rake_tasks do
      load 'jasminerice-runner/tasks/jasminerice-runner.rake'
    end
  end
end
