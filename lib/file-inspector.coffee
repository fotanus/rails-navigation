fs = require 'fs'
q = require 'q'
inflection = require 'inflection'

# FileInspector understands the rails project directory architecture and can be
# used to get information about it.
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


  # Public: Test if a file path is a controller file path.
  #
  # file - the file path
  #
  # Returns a boolean
  @isController: (file) ->
    Boolean(file.match controllerFileMatcher)

  # Public: Test if a file path is a test (rspec or unit) file path.
  #
  # file - the file path
  #
  # Returns a boolean
  @isTest: (file) ->
    Boolean(file.match(specFileMatcher) || file.match(testFileMatcher))

  # Public: Test if a file path is a model file path.
  #
  # file - the file path
  #
  # Returns a boolean
  @isModel: (file) ->
    Boolean(file.match(modelFileMatcher))

  # Public: Test if a file path is a spec file path.
  #
  # file - the file path
  #
  # Returns a boolean
  @isSpec: (file) ->
    Boolean(file.match(specFileMatcher))

  # Public: Gets the best model file path for the given parameters
  #
  # model - a model string, singularized
  #
  # Returns a promise of the file path
  @modelFilePath: (model) ->
    q.fcall ->
      "app/models/#{model}.rb"

  # Public: Gets the best controller file path for the given parameters
  #
  # model - a model string, singularized
  #
  # Returns a promise of the file path
  @controllerFilePath: (model) ->
    pluralFilePath = "app/controllers/#{inflection.pluralize(model)}_controller.rb"
    singularFilePath = "app/controllers/#{model}_controller.rb"
    @firstFileThatExists(pluralFilePath, singularFilePath)

  # Public: Gets the best helper file path for the given parameters
  #
  # model - a model string, singularized
  #
  # Returns a promise of the file path
  @helperFilePath: (model) ->
    pluralFilePath = "app/helpers/#{inflection.pluralize(model)}_helper.rb"
    singularFilePath = "app/helpers/#{model}_helper.rb"
    @firstFileThatExists(pluralFilePath, singularFilePath)

  # Public: Gets the best migration file path that creates the related model
  #
  # model - a model string, singularized
  #
  # Returns a promise of the file path
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

  # Public: Gets the best view file path for the given parameters
  #
  # model - a model string, singularized
  # action - the action (or view name base)
  #
  # Returns a promise of the file path
  @viewFilePath: (model, action) ->
    deffered = q.defer()
    pluralizedModel = inflection.pluralize(model)
    pluralizedViewsPath = "app/views/#{pluralizedModel}"
    singularViewsPath = "app/views/#{model}"
    viewsFilePathPromise = @firstFileThatExists(pluralizedViewsPath, singularViewsPath)
    viewsFilePathPromise.then (viewsPath) ->
      console.log viewsPath
      console.log FileInspector.fullPath(viewsPath)
      fs.readdir FileInspector.fullPath(viewsPath)  , (err, files) ->
        if err
          console.log(err)
          deffered.resolve(null)
        else
          for file in files
            if file.match new RegExp(action + "\\.\\w+(\\.\\w+)?")
              return deffered.resolve("#{viewsPath}/#{file}")
        deffered.resolve(null)

    return deffered.promise

  # Public: Gets the best test file path for the given parameters. It works for
  # both Test::Unit and rspec.
  #
  # sourceFilePath - the file which we want to know the test file path.
  #
  # Returns a promise of the file path
  @testFilePath: (sourceFilePath) ->
    specFilePath = sourceFilePath
      .replace(/^app/, "spec")
      .replace(/erb/, "erb.rb")
      .replace(/\.rb$/, "_spec.rb")
    unitTestFilePath = sourceFilePath
      .replace(/^app/, "test")
      .replace(/erb/, "erb.rb")
      .replace(/\.rb$/, "_test.rb")

    return @firstFileThatExists(specFilePath, unitTestFilePath)

  # Private: Given two files, returns the first one that exists.
  #
  # file1 - the first file, which have priority over file2
  # file2 - the second file
  #
  # Returns a promise for one of the input files, or null
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

  # Private: For a given rails file, gets the model name associated with it.
  #
  # file - any rails file path
  #
  # Returns the singularized model, or null
  @getModelName: (file) ->
    regexps = [
      modelSpecMatcher,
      controllerSpecMatcher,
      viewSpecMatcher,
      mailerSpecMatcher,
      modelFileMatcher,
      controllerFileMatcher,
      viewFileMatcher,
      legacyViewFileMatcher,
      mailerMatcher,
      helperFileMatcher,
      migrationCreateFileMatcher,
      migrationModifyFileMatcher,
      factoryMatcher,
    ]

    for regexp in regexps
      if match = file.match regexp
        return inflection.singularize(match[1])

  # Public: For a given editor, try to find the related action of the current
  # file path.
  #
  # editor - the editor which holds the file we want to extract the action from.
  #
  # Returns the action, or null
  @getActionName: (editor) ->
    filePath = editor.getPath()
    if filePath
      if match = filePath.match viewFileMatcher
        return match[2]
      if match = filePath.match legacyViewFileMatcher
        return match[2]
    null

  # Private: For a given relative rails file path, gets the full file path.
  #
  # partialPath - the relative file path
  #
  # Returns the full file path
  @fullPath: (partialPath) ->
    if atom.project
      "#{atom.project.getPath()}/#{partialPath}"
    else
      ""
