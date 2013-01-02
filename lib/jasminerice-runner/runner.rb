module Jasminerice
  class Runner

    include Capybara::DSL

    def capybara_driver
      self.class.capybara_driver || :selenium
    end

    def run(jasmine_environment)
      Capybara.default_driver = capybara_driver
      url = "/jasmine"

      if jasmine_environment.present?
        url += "?environment=#{jasmine_environment}"
      end
      visit url
      print "Running jasmine specs"

      begin
        wait_for_finished
      rescue
        if jasmine_environment.present?
          filename = "#{jasmine_environment}_spec.js"
        else
          filename = "spec.js"
        end
        puts "\njasmineRiceReporter not defined! Check your configuration to make\n" +
             "sure that #{filename} exists and that jasminerice_reporter is included."
      end

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

    def wait_for_finished
      reporter = page.evaluate_script("window.jasmineRiceReporter")
      if reporter.nil?
        raise "Reporter not found"
      end

      start = Time.now
      while true
        break if page.evaluate_script("window.jasmineRiceReporter.finished")
        sleep 1
        print "."
      end
      print "\n"
    end
  end
end
