jasminerice-runner
==================

**The original repo hasn't been updated in 4 years , this fork though tries to keep up-to-date with latest updates.**

Uses capybara to run jasmine specs with jasminerice and rails asset pipeline

Requirements
------------

1.	[capybara >= 2.0](https://github.com/celluloid/celluloid)
2.	[jasminerice >= 0.0.10](https://github.com/jwo/celluloid-pmap)
3.	[jasmine >= 1.1](https://github.com/bogdanRada/celluloid_pubsub)
4.	[nokogiri >= 1.6](https://github.com/swoop-inc/composable_state_machine)
5.	[colorize >= 0.8](https://github.com/tj/terminal-table)
6.	[coffee-script >= 2.0](https://github.com/fazibear/colorize)

Compatibility
-------------

Rails 4.0 or greater ( currently this was tested only with Rails), but i can accept pull requests for other rack-based applications
[MRI >= 2.0](http://www.ruby-lang.org)

Rubinius,  Jruby, MRI 1.8, MRI 1.9 are not officially supported.

Installation Instructions
-------------------------

Add it to your Gemfile
```ruby
    gem "jasminerice-runner"
```
Usage
-----

For Jasmine <2.0 add this to your spec.js:

```coffee
    #= require jasminerice_runner_base
    #= require jasminerice_legacy_reporter
```

For Jasmine > 2.0 add this to your spec.js:

```coffee
    #= require jasminerice_runner_base
    #= require jasminerice_reporter
```


Then, run the rake task

```sh
    rake jasminerice:run
```
To switch drivers, in a config/initializer

```ruby
    Jasminerice::Runner.configure do |config|
        # you can use any other driver (phantomjs, or other drivers)
        config.capybara_driver = :webkit

        # For Jasmine < 2.0, this gem also provides a Junit XML formatter ( for Jasmine > 2.0 this will have no effect )
        # If you want to enable the JUNIT XML Formatter you need to specify `:junit_xml`
        # By Default this is set to nil, however if the environment variable CI is present and has as value 'true',
        # and you are using Jasmine < 2.0, this will be automatically set to :junit_xml
        # unless of course this is not overidden in a initializer
        config.formatters = nil

        # For Jasmine < 2.0, this gem also provides a Junit XML formatter ( for Jasmine > 2.0 this will have no effect )
        config.junit_xml_path = File.join(Dir.pwd, 'spec', 'reports')
    end
```


**Default driver is :selenium***


Using other formatters for Jasmine > 2.0
-----------------------------------

 Starting with version 2.0 , Jasmine supports custom formatters by using this configuration:


```ruby

    Jasmine.configure do |config|
        config.formatters << Jasmine::Formatters::JunitXml
    end
```

Put this configuration in a file located in **config/initializers**.

But in order for this to work , you will have to add the gem **jasmine_junitxml_formatter** to your Gemfile


Using Multiple Jasmine Environments
-----------------------------------

If your app has multiple jasmine environments, you can specify the runner
to only run jasmine tests for that environment. Adding an environment will
run the file "#{ENVIRONMENT}_spec.js". The default spec file (spec.js) will be run
if no environment is specified.

For example, if you wanted to run all specs in admin_spec.js the rake task would be:

    rake jasminerice:run["admin"]
