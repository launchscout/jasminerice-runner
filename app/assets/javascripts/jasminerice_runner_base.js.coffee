class JasminericeRunnerBase
  constructor: ->
    @started = false
    @finished = false
    @failedSpecs = []
    @totalCount = 0
    @failedCount = 0
    @failure_message = 'Failure/Error: '
    # additional data ( optional )
    @suites_ = {}
    @results_ = {}
    @final_results_ = {}

  results: ->
    @results_

  all_summarized_results: ->
    summarized_results = []
    for key, value of @final_results_
      summarized_results.push(value)
    summarized_results

  suites: ->
    @suites_

  extend_object: (object, properties) ->
    for key, val of properties
      object[key] = val
    object

  resultsForSpec: (specId) ->
    @results_[specId]

  getFullDescOfSuite: (suite) ->
    desc = ""
    while(suite.parentSuite)
      desc = suite.description + " " + desc
      suite = suite.parentSuite
    desc = suite.description + " " + desc
    desc

  reportRunnerStarting: (runner) ->
    @started = true
    suites = runner.topLevelSuites()
    for i in [0...suites.length]
      suite = suites[i]
      @suites_[suite.id] = @.summarize_(suite)

  summarize_ : (suiteOrSpec) ->
    isSuite = suiteOrSpec instanceof jasmine.Suite
    summary = {
      id: suiteOrSpec.id,
      name: suiteOrSpec.description,
      type: if isSuite then 'suite' else 'spec',
      children: []
    }
    if (isSuite && suiteOrSpec.hasOwnProperty('children'))
      children = suiteOrSpec.children()
      for i in [0...children.length]
        summary.children.push(@.summarize_(children[i]))
    summary

  inspect: ->
    {
      'started':        @started,
      'finished':       @finished,
      'totalCount':     @totalCount,
      'failedCount':    @failedCount
      'failedSpecs':    @failedSpecs
    }

  log: (str) ->
    console.log(str)

  bindEvent: (eventHandler) ->
    eventName = 'DOMContentLoaded'
    if (document.addEventListener)
      document.addEventListener(eventName, eventHandler, false)
    else if (document.attachEvent)
      document.attachEvent('on'+eventName, eventHandler)

  register: ->
    @.bindEvent( =>
      @.registerIntoJasmine()
    )

  registerIntoJasmine: ->
    jasmine.getEnv().addReporter(window.jasmineRiceReporter)

window.JasminericeRunnerBase = JasminericeRunnerBase
