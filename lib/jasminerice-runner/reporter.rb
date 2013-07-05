module Jasminerice
  class Reporter

    def report(results)
      puts "Jasmine results - Passed: #{results[:passed]} Failed: #{results[:failed]} Total: #{results[:total]}"
      failures = results[:failures]

      if failures.size == 0
        puts "Jasmine specs passed, yay!"
      else
        report_failures(failures)
        raise "Jasmine specs failed"
      end
    end

    def report_failures(failures)
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
  end
end
