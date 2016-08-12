if defined?(Rails)
  class Jasminerice::Runner::Engine < Rails::Engine

    config.assets.precompile += %w(
      jasminerice_runner_base.js.coffee
      jasminerice_legacy_reporter.js.coffee
      jasminerice_reporter.js.coffee
    )

    rake_tasks do
      load 'jasminerice-runner/tasks/jasminerice-runner.rake'
    end
  end
end
