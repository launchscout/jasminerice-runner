module Jasminerice
  module Runner
    class Configuration
      SETTINGS = [:capybara_driver, :formatters, :junit_xml_path]

        SETTINGS.each do |setting|
          attr_accessor setting
        end

        def initialize
          @capybara_driver = nil
          @formatters = ENV['CI'].to_s == 'true' && !Jasmine.respond_to?(:configure) ? [:junit_xml] : []
          @junit_xml_path = nil
        end

        def gem_root
          File.expand_path(File.dirname(__dir__))
        end

        def formatters
          (@formatters.is_a?(Array) ? @formatters : [@formatters]).compact
        end
      end
    end
  end
