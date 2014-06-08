AR = require './active-record'
fs = require 'fs'
q = require 'q'

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
  migrationModifyFilematcher = /\/migrate\/[0-9]+_add_\w+_to_(\w+)\.rb$/

  # Returns wheter a file path is a controller or not
  @isController: (file) ->
    Boolean(file.match controllerFileMatcher)

  # Given a model name, returns the file path for that model.
  @modelFilePath: (model) ->
    "app/models/#{model}.rb"

  # Given a model name, returns the file path for the respective controller
  @controllerFilePath: (model) ->
    "app/controllers/#{AR.pluralize(model)}_controller.rb"

  # Given a model name, returns the file path for the respective helper
  @helperFilePath: (model) ->
    "app/helpers/#{AR.pluralize(model)}_helper.rb"

  # Given a model name, returns the migration that creates it
  # It only works for migrations with the name
  # Returns undefined if not found
  @migrationFilePath: (model) ->
    pluralizedModel = AR.pluralize(model)
    files = fs.readdirSync atom.project.getPath() + "/db/migrate"
    for file in files
      if file.match new RegExp("[0-9]+_create_" + pluralizedModel + "\.rb")
        return "db/migrate/#{file}"

  # Given the model name and an action, returns the path for the
  # default view file for this action.
  @viewFilePath: (model, action) ->
    pluralizedModel = AR.pluralize(model)
    modelViewsPath = "#{atom.project.getPath()}/app/views/#{pluralizedModel}"
    files = fs.readdirSync modelViewsPath
    for file in files
      if file.match new RegExp(action + "\\.\\w+(\\.\\w+)?")
        return "app/views/#{pluralizedModel}/#{file}"
    null


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
      migrationModifyFilematcher
    ]

    for regexp in regexps
      if match = file.match regexp
        return AR.singularize(match[1])

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
