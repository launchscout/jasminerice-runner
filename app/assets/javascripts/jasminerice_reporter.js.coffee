#= require ./jasminerice_runner_base
class JasminericeReporter extends window.JasminericeRunnerBase
  constructor : ->
    super
    @runner_results = []

  jasmineStarted: (suiteInfo) ->
    @started = true
    @failedSpecs = []
    @totalCount = 0
    @failedCount = 0
    #@.log('Running suite with ' + suiteInfo.totalSpecsDefined)

  suiteStarted: (result) ->
    @suites_[suite.id] = @.summarize_(result)
    #@.log('Suite started: ' + result.description + ' whose full description is: ' + result.fullName)

  specStarted: (result) ->
    #@.log('Spec started: ' + result.description + ' whose full description is: ' + result.fullName)

  specDone: (spec) ->
    spec_result = if spec.failedExpectations.length > 0 then "failed" else "passed"
    spec_id = spec.id
    @totalCount++
    @results_[spec_id] = {
      'status': spec_result
      'messages': spec.failedExpectations,
      'id': spec_id,
      'description': spec.description,
      'full_name': spec.fullName
    }
    @final_results_[spec_id] = @.summarizeResult_(spec, @results_[spec_id])
    if spec_result == 'failed'
      @failedCount++
      @failedSpecs.push(@final_results_[spec_id])

  summarizeResult_ : (spec, result) ->
    summaryMessages = []
    for messageIndex in [0...result.messages.length]
      resultMessage = result.messages[messageIndex]
      summaryMessages.push({
        'status': result.status,
        'message': resultMessage.message,
        'matcherName': resultMessage.matcherName,
        'expected': ''+resultMessage.expected,
        'actual': ''+resultMessage.actual,
        'trace': {
          'stack': if !resultMessage.passed then resultMessage.stack else jasmine.undefined
        }
      })
    {
      'id': result.id,
      'status': result.status
      'name': result.full_name,
      'description': result.description
      'messages': summaryMessages,
    }

  suiteDone: (result) ->
    #The result here is the same object as in suiteStarted but with the addition of a status and a list of failedExpectations.
    @.log('Suite: ' + result.description + ' was ' + result.status);

  jasmineDone: ->
    @finished = true

# make sure this exists so we don't have timing issue
# when capybara hits us before the onload function has run
window.jasmineRiceReporter = new JasminericeReporter()
window.jasmineRiceReporter.register()
