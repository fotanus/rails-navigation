fs = require 'fs'
q = require 'q'
inflection = require 'inflection'

# FileInspector class does inferences and can answer queries
# related to rails file paths

module.exports =
class FileInspector

  # Regular expressions used to match file type that is being used. Returns the
  # model name, pluralized or not.
  modelFileMatcher = /\/models\/(\w+)\.rb$/
  controllerFileMatcher = /\/controllers\/(\w+)_controller\.rb$/
  viewFileMatcher = /\/views\/(\w+)\/(.+)\.\w+\.\w+$/
  legacyViewFileMatcher = /\/views\/(\w+)\/(.+)\.\w+$/
  helperFileMatcher = /\/helpers\/(\w+)_helper\.rb$/
  migrationCreateFileMatcher = /\/migrate\/[0-9]+_create_(\w+)\.rb$/
  migrationModifyFileMatcher = /\/migrate\/[0-9]+_add_\w+_to_(\w+)\.rb$/
  mailerMatcher = /\/mailers\/(\w+).rb/
  factoryFileMatcher = /\/factories\/(\w+).rb/

  # Regular expressions that matches any test file
  specFileMatcher = /spec\/.*_spec\.rb/
  testFileMatcher = /test\/.*_test\.rb/

  # Regular expressions to extract information from test files
  unitTestFileMatcher = /test\/unit\/(\w+)_test\.rb/
  functionalTestFileMatcher = /test\/functional\/(\w+)_test\.rb/

  modelSpecMatcher = /spec\/models\/(\w+)_spec.rb/
  controllerSpecMatcher = /spec\/controllers\/(\w+)_controller_spec\.rb/
  viewSpecMatcher = /spec\/views\/(\w+)\/(\w+)\.\w+\.\w+_spec\.rb/
  mailerSpecMatcher = /spec\/mailers\/(\w+)_spec.rb/
  factoryMatcher = /factories\/(\w+)\.rb/


  # Returns wheter a file path is a controller
  @isController: (file) ->
    Boolean(file.match controllerFileMatcher)

  # Returns wheter a file path is from a test
  @isTest: (file) ->
    Boolean(file.match(specFileMatcher) || file.match(testFileMatcher))

  # Given a model name, returns the file path for that model.
  @modelFilePath: (model) ->
    q.fcall ->
      "app/models/#{model}.rb"

  # Given a model name, returns the file path for the respective controller
  @controllerFilePath: (model) ->
    pluralFilePath = "app/controllers/#{inflection.pluralize(model)}_controller.rb"
    singularFilePath = "app/controllers/#{model}_controller.rb"
    @firstFileThatExists(pluralFilePath, singularFilePath)

  # Given a model name, returns the file path for the respective helper
  @helperFilePath: (model) ->
    pluralFilePath = "app/helpers/#{inflection.pluralize(model)}_helper.rb"
    singularFilePath = "app/helpers/#{model}_helper.rb"
    @firstFileThatExists(pluralFilePath, singularFilePath)

  # Given a model name, returns the migration that creates it
  # It only works for migrations with the name
  # Returns undefined if not found
  @migrationFilePath: (model) ->
    deffered = q.defer()
    promise = fs.readdir atom.project.getPath() + "/db/migrate", (err, files) ->
      if err
        deffered.resolve(null)
      else
        pluralizedModel = inflection.pluralize(model)
        bestFound = null
        for file in files
          if file.match new RegExp("[0-9]+_create_" + pluralizedModel + "\.rb")
            return "db/migrate/#{file}"
          if file.match new RegExp("[0-9]+_create_" + model + "\.rb")
            bestFoud = "db/migrate/#{file}" unless bestFound
        deffered.resolve(bestFound)
    deffered.promise

  # Given the model name and an action, returns the path for the
  # default view file for this action.
  @viewFilePath: (model, action) ->
    deffered = q.defer()
    pluralizedModel = inflection.pluralize(model)
    pluralizedViewsPath = "app/views/#{pluralizedModel}"
    singularViewsPath = "app/views/#{model}"
    viewsFilePathPromise = @firstFileThatExists(pluralizedViewsPath, singularViewsPath)
    viewsFilePathPromise.then (viewsPath) ->
      if viewsPath
        files = fs.readdir @fullPath viewsPath, (err, files) ->
          if err
            deffered.resolve(null)
          else
            for file in files
              if file.match new RegExp(action + "\\.\\w+(\\.\\w+)?")
                deffered.resolve("#{viewsPath}/#{file}")
            deffered.resolve(null)
      else
        deffered.resolve(null)

    return deffered.promise

  # Given the model name and an action, returns the path for the
  # test file for it.
  @testFilePath: (sourceFilePath) ->
    specFilePath = sourceFilePath
      .replace(/^app/, "spec")
      .replace(/erb/, "erb.rb")
      .replace(/\.rb$/, "_spec.rb")
    unitTestFilePath = sourceFilePath
      .replace(/^app/, "test")
      .replace(/erb/, "erb.rb")
      .replace(/\.rb$/, "_test.rb")
    console.log specFilePath

    return @firstFileThatExists(specFilePath, unitTestFilePath)

  # Given two file paths, returns one that exists. The first one has priority
  # over the second one. If no file exists, return null
  @firstFileThatExists: (file1, file2) ->
    deffered = q.defer()
    fullPathFile1 = @fullPath(file1)
    fullPathFile2 = @fullPath(file2)
    fs.exists fullPathFile1, (exists) ->
      if exists
        deffered.resolve(file1)
      else
        fs.exists fullPathFile2, (exists) ->
          if exists
            deffered.resolve(file2)
          else
            deffered.resolve(null)
    return deffered.promise

  # This is the base method used to navigational purposes.
  # It returns the model name from the current file.
  @getModelName: (file) ->
    regexps = [
      modelFileMatcher,
      controllerFileMatcher,
      viewFileMatcher,
      legacyViewFileMatcher,
      helperFileMatcher,
      migrationCreateFileMatcher,
      migrationModifyFileMatcher,
      modelSpecMatcher,
      controllerSpecMatcher,
      viewSpecMatcher,
      mailerSpecMatcher,
      factoryMatcher,
    ]

    for regexp in regexps
      if match = file.match regexp
        return inflection.singularize(match[1])

  # When possible to define the action based on the file name, returns it.
  # Returns null otherwise.
  @getActionName: (editor) ->
    filePath = editor.getPath()
    if filePath
      if match = filePath.match viewFileMatcher
        return match[2]
      if match = filePath.match legacyViewFileMatcher
        return match[2]
    null

  # Gives full path for a partial path on the open project
  @fullPath: (partialPath) ->
    if atom.project
      "#{atom.project.getPath()}/#{partialPath}"
    else
      ""
