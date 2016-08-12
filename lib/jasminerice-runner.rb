# frozen_string_literal: true
require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'colorize'
require 'capybara'
require 'capybara/dsl'
require 'jasmine'
require 'nokogiri'
require 'jasminerice'
require 'coffee-script'

require 'thread'
require 'fileutils'
require 'pathname'

%w(formatters).each do |folder_name|
  Gem.find_files("jasminerice-runner/#{folder_name}/**/*.rb").each { |path| require path }
end


module Jasminerice
  module Runner
    require 'jasminerice-runner/configuration'
    require 'jasminerice-runner/worker'
    require 'jasminerice-runner/version'
    require 'jasminerice-runner/engine' if defined?(Rails)

    def self.configure
      yield config
    end

    def self.config
      @config ||= Jasminerice::Runner::Configuration.new
    end
  end
end
