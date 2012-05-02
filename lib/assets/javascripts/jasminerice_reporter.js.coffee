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


jQuery ->
  window.jasmineRiceReporter = new JasminericeReporter()
  jasmine.getEnv().addReporter jasmineRiceReporter
