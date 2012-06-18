module Jasminerice
  class Runner
    
    include Capybara::DSL
    
    def capybara_driver
      self.class.capybara_driver || :selenium
    end
    
    def run
      Capybara.default_driver = capybara_driver
      visit "/jasmine"
      puts "Running jasmine specs"
      wait_until { page.evaluate_script("window.jasmineRiceReporter.finished")}
      passed = page.evaluate_script("window.jasmineRiceReporter.results.passedCount")
      failed = page.evaluate_script("window.jasmineRiceReporter.results.failedCount")
      total = page.evaluate_script("window.jasmineRiceReporter.results.totalCount")
      failures = page.evaluate_script("window.jasmineRiceReporter.failedSpecs")
      puts "Jasmine results - Passed: #{passed} Failed: #{failed} Total: #{total}"
      if failures.size > 0
        puts 'Jasmine failures:  '
        for suiteName,suiteFailures in failures
          puts "  " + suiteName + "\n"
          for specName,specFailures in suiteFailures
            puts "    " + specName + "\n"
            for specFailure in specFailures
              puts "      " + specFailure + "\n"
            end
          end
          puts "\n"
        end
      end
  
      if page.evaluate_script("window.jasmineRiceReporter.results.failedCount") == 0
        puts "Jasmine specs passed, yay!"
      else
        raise "Jasmine specs failed"
      end
    end
    
  end
end