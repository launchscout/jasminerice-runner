jasminerice-runner
==================

Uses capybara to run jasmine specs with jasminerice and rails asset pipeline

Usage
-----

Add it to your Gemfile

    gem "jasminerice-runner"
    
Add this to your spec.js:

    #= require jasminerice_reporter
  
Then, run the rake task

    rake jasminerice:run
    
To switch drivers, in a config/initializer

    Jasminerice::Runner.capybara_driver = :webkit
    
Default driver is :selenium

Using Multiple Jasmine Environments
-----------------------------------

If your app has multiple jasmine environments, you can specify the runner
to only run jasmine tests for that environment. Adding an environment will
run the file "#{ENVIRONMENT}_spec.js". The default spec file (spec.js) will be run
if no environment is specified.

For example, if you wanted to run all specs in admin_spec.js the rake task would be:

    rake jasminerice:run["admin']
