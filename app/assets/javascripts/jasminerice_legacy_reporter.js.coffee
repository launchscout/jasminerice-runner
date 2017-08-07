#= require ./jasminerice_runner_base
class JasminericeLegacyReporter extends window.JasminericeRunnerBase
  constructor : ->
    super

  reportRunnerStarting: (runner) ->
    super(runner)

  reportRunnerResults: (runner) ->
    @finished = true

  reportSpecResults: (spec) ->
    spec_result = if spec.results().failedCount > 0 then "failed" else "passed"
    spec_id = spec.id
    @totalCount++
    @results_[spec_id] = {
      'status': spec_result
      'messages': spec.results().getItems(),
      'id': spec_id,
      'description': spec.description,
      'suite': spec.suite,
      'full_name': spec.getFullName()
    }
    @final_results_[spec_id] = @.summarizeResult_(spec, @results_[spec_id])
    if spec_result == 'failed'
      @failedCount++
      @failedSpecs.push(@final_results_[spec_id])

  resultsForSpecs : (specIds) ->
    results = {}
    for i in [0...specIds.length]
      specId = specIds[i]
      results[specId] = @.summarizeResult_(specIds[i], @results_[specId])
    results

  summarizeResult_ : (spec, result) ->
    summaryMessages = []
    for messageIndex in [0...result.messages.length]
      resultMessage = result.messages[messageIndex]
      summaryMessages.push({
        'status': if resultMessage.passed then resultMessage.passed() else true,
        'message': resultMessage.message,
        'matcherName': resultMessage.matcherName,
        'expected': ''+resultMessage.expected,
        'actual': ''+resultMessage.actual,
        'trace': {
          'stack': if resultMessage.passed && !resultMessage.passed() then resultMessage.trace.stack else jasmine.undefined
        }
      })
    {
      'id': result.id,
      'status': result.status
      'name': result.full_name,
      'description': result.description
      'messages': summaryMessages,
      'suite_name': @.getFullDescOfSuite(result.suite),
    }
    
# make sure this exists so we don't have timing issue
# when capybara hits us before the onload function has run
window.jasmineRiceReporter = new JasminericeLegacyReporter()
window.jasmineRiceReporter.register()
