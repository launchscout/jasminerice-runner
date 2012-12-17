module Jasminerice
  class Runner
    cattr_accessor :capybara_driver
    cattr_accessor :timeout
  end
  class JasmineRiceRunnerEngine < Rails::Engine
  end
end
