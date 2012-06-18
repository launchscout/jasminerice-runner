jasminerice-runner
==================

Uses capybara to run jasmine specs with jasminerice and rails asset pipeline

Usage
-----

Add this to your spec.js:

    #= require jasminerice_reporter
  
Then, run the rake task

    rake jasminerice:run
    
To switch drivers, in a config/initializer

    Jasminerice::Runner.capybara_driver = :webkit
    
Default driver is :selenium