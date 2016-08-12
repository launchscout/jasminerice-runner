module Jasminerice
  module Runner
    class Worker
      include Capybara::DSL

      FOMATTERS_MAPPER = {
        junit_xml: {
          legacy: Jasminerice::Runner::Formatters::LegacyJunitXml,
        }
      }.freeze

      attr_reader :environment

      def initialize(environment)
        @environment = environment
        @finished = false
        @total_runned_tests = 0
        @test_statuses = {}
      end

      def formatter_name(formatter, type = :legacy)
        type = type.is_a?(Symbol) ? type : type.to_sym
        formatter_name = formatter.is_a?(Symbol) ? formatter : formatter.to_sym
        Jasminerice::Runner::Worker::FOMATTERS_MAPPER[formatter_name][type]
      end

      def runner_formatters
        Jasminerice::Runner.config.formatters
      end

      def junit_enabled?
        runner_formatters.include?(:junit_xml)
      end

      def capybara_driver
        Jasminerice::Runner.config.capybara_driver || :selenium
      end

      def filter_failures_allowed_keys(failures)
        failures.map do |hash|
          hash['messages'] = hash['messages'].map {|message| message.slice('message', 'trace') }
          hash.select do |key, value|
            ['name', 'messages'].include?(key.to_s)
          end
        end
      end

      def run
        Capybara.default_driver = capybara_driver
        visit jasmine_url
        print "Running jasmine specs"
        wait_for_finished
        results = get_results
        #puts JSON.pretty_generate(results)
        puts "Jasmine results - Failed: #{results[:failed]} Total: #{results[:total]}"
        failures = results[:failures]
        failures = (failures.is_a?(Array) ? failures : [failures]).compact

        if failures.size == 0
          puts "Jasmine specs passed, yay!"
        else
          puts 'Jasmine failures:  '
          puts "\n"
          filtered_failures = filter_failures_allowed_keys(failures)
          formatted_results = report_failures(filtered_failures)
          print_formatted_failures(formatted_results)
          puts "Jasmine specs failed"
        end
        if !Jasmine.respond_to?(:configure) && !value_blank?(runner_formatters)
          runner_formatters.each do |formatter|
            formatter_instance =  formatter_name(formatter, :legacy).new(self)
            formatter_instance.format(results[:all_results])
            formatter_instance.done({})
          end
        end
        exit
      end

      def jasmine_url
        url = "/jasmine"
        if @environment.present?
          url += "/#{@environment}"
        else
          url +='#/index'
        end
        url
      end

      def get_results
        {
          failed: page.evaluate_script("window.jasmineRiceReporter.failedCount"),
          total: page.evaluate_script("window.jasmineRiceReporter.totalCount"),
          failures: page.evaluate_script("window.jasmineRiceReporter.failedSpecs"),
          all_results: page.evaluate_script("window.jasmineRiceReporter.all_summarized_results()")
        }
      end

      def print_formatted_failures(formatted_results)
        formatted_results.each_with_index do |failure_hash, index|
          print "#{(index + 1)}) "
          failure_hash.each do |key, value|
            print print_color(key, value.to_s) + "\n"
          end
          puts "\n"
        end
      end

      def report_failures(failures, array = [])
        return unless failures.is_a?(Array)
        failures.each_with_index do |failure, index|
          collect_failure(failure, index, array)
        end
        array.compact
      end

      def value_blank?(value)
        value.nil? || value_empty?(value) || (value.is_a?(String) && /\A[[:space:]]*\z/.match(value))
      end

      def value_empty?(value)
        value.respond_to?(:empty?) ? value.empty? : !value
      end

      def collect_failure(failure, index, array)
        failure.each do |key, value|
          if value.is_a?(Hash)
            collect_failure(value, index, array)
          elsif value.is_a?(Array)
            value.each { |array_value|  collect_failure(array_value, index, array) }
          elsif !value.nil? && !value_blank?(value)
            array[index] ||= {}
            array[index][key] =  print_color(key, value.to_s).uncolorize
          end
        end
      end

      def print_color(key, value)
        case key.to_s
        when 'message'
          "Failure/Error: #{value}"
        when 'stack'
          "Backtrace: #{value.red}"
        else
          value
        end
      end

      def wait_for_finished
        start_time = Time.now
        reporter = page.evaluate_script("typeof(window.jasmineRiceReporter)")
        if reporter.nil? || reporter !='object'
          if @environment.present?
            filename = "#{@environment}_spec.js"
          else
            filename = "spec.js"
          end
          puts "\njasmineRiceReporter not defined! Check your configuration to make\n" +
          "sure that #{filename} exists and that jasminerice_reporter is included."
          raise "Reporter not found"
        end
        loop do
          @finished = page.evaluate_script("window.jasmineRiceReporter.finished")
          break if @finished
          sleep(0.1)
          print "."
        end
        print "\n"
        duration = Time.now - start_time
        puts "Jasmine test Duration was #{duration.inspect}"
      end
    end
  end
end
