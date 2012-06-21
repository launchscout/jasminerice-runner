class JasminericeReporter
  @failedSpecs = {}
  reportRunnerResults: (runner)->
    @finished = true
    @results = runner.results()

  reportSpecResults: (spec) ->
    #return if @failed
    @failedSpecs or= {}
    if spec.results().failedCount > 0
      failure = ''
      for expectation in spec.results().getItems()
        if !expectation.passed()
          failure = expectation.message
          @failedSpecs[spec.suite.description] or= {}
          @failedSpecs[spec.suite.description][spec.description] or= []
          @failedSpecs[spec.suite.description][spec.description].push(failure)
#@failed = true

# make sure this exists so we don't have timing issue
# when capybara hits us before the onload function has run
window.jasmineRiceReporter = new JasminericeReporter()

jQuery ->
  jasmine.getEnv().addReporter window.jasmineRiceReporter
