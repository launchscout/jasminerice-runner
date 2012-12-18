module Jasminerice
  class Runner

    include Capybara::DSL

    def capybara_driver
      self.class.capybara_driver || :selenium
    end

    def timeout
      self.class.timeout || 60
    end

    def get property
      page.evaluate_script("window.jasmineRiceReporter.#{property}")
    end

    def run
      Capybara.default_driver = capybara_driver
      visit "/jasmine"
      puts  "Running jasmine specs"
      wait_until (timeout) { get "finished" }
      failures = get "failures"
      passed   = get "results.passedCount"
      failed   = get "results.failedCount"
      total    = get "results.totalCount"

      banner = "Jasmine results - Passed: #{passed} Failed: #{failed} Total: #{total}"
      puts "." * banner.length
      puts banner
      puts "." * banner.length

      if failures.size > 0
        puts "\nFailures:\n"
        indent = ""
        for ancestors, messages in failures
          for name in ancestors.split(",")
            puts "#{indent}#{name}"
            indent += "  "
          end
          for message in messages
            puts "#{indent}#{message}"
          end

          indent = ""
          puts "\n"
        end

      end

      if get("failedCount") == 0
        puts "Jasmine specs passed, yay!"
      else
        raise "Jasmine specs failed"
      end
    end

  end
end