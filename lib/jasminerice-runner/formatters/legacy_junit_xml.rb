module Jasminerice
  module Runner
    module Formatters
      class LegacyJunitXml

        attr_reader :worker, :doc, :spec_count, :failure_count

        def initialize(worker)
          @doc = Nokogiri::XML '<testsuites><testsuite name="Jasmine Suite"></testsuite></testsuites>', nil, 'UTF-8'
          @worker = worker
          @spec_count = 0
          @failure_count = 0
        end

        def format(results)
          testsuite = doc.at_css('testsuites testsuite')

          @spec_count += results.size

          results.each do |result|
            testcase = Nokogiri::XML::Node.new 'testcase', doc
            testcase['classname'] = result['suite_name'].to_s.strip
            testcase['name'] = result['description'].to_s.strip

            if result['status'] == 'failed'
              @failure_count += 1
              result['messages'].each do |failed_exp|
                failure = Nokogiri::XML::Node.new 'failure', doc
                failure['message'] = failed_exp['message'].to_s.strip
                failure['type'] = 'Failure'
                failure.content = failed_exp['trace']['stack'].to_s.strip
                failure.parent = testcase
              end
            end

            testcase.parent = testsuite
          end
        end

        def done(run_details)
          testsuite = doc.at_css('testsuites testsuite')
          properties = Nokogiri::XML::Node.new 'properties', doc
          properties.parent = testsuite

          if run_details['order']
            random = Nokogiri::XML::Node.new 'property', doc
            random['name'] = 'random'
            random['value'] = run_details['order']['random']

            random.parent = properties

            if run_details['order']['random']
              seed = Nokogiri::XML::Node.new 'property', doc
              seed['name'] = 'seed'
              seed['value'] = run_details['order']['seed']

              seed.parent = properties
            end
          end

          testsuite['tests'] = @spec_count
          testsuite['failures'] = @failure_count
          testsuite['errors'] = 0
          FileUtils.mkdir_p(output_dir) unless File.directory?(output_dir)
          File.open(File.join(output_dir, 'junit_results.xml'), 'w') do |file|
            file.puts doc.to_xml(indent: 2)
          end
        end

        private

        def output_dir
          config_path = Jasminerice::Runner.config.junit_xml_path
          @output_dir ||= worker.value_blank?(config_path) ? File.join(Dir.pwd, 'spec', worker.environment.to_s, 'reports') : config_path
        end

      end
    end
  end
end
