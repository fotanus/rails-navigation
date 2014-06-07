AR = require './active-record'
fs = require 'fs'

# Navigation class contains methods used to navigate on
# rails directory structure

module.exports =
class Navigation

  # Regular expressions used to match file type that is being used. Returns the
  # model name, pluralized or not.
  modelFileMatcher = /\/models\/(\w+)\.rb$/
  controllerFileMatcher = /\/controllers\/(\w+)_controller\.rb$/
  viewFileMatcher = /\/views\/(\w+)\/(.+)\.\w+\.\w+$/
  helperFileMatcher = /\/helpers\/(\w+)_helper\.rb$/
  migrationCreateFileMatcher = /\/migrate\/[0-9]+_create_(\w+)\.rb$/
  migrationModifyFilematcher = /\/migrate\/[0-9]+_add_\w+_to_(\w+)\.rb$/

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
    pluralized_model = AR.pluralize(model)
    files = fs.readdirSync atom.project.getPath() + "/db/migrate"
    for file in files
      if file.match new RegExp("[0-9]+_create_" + pluralized_model + "\.rb")
        return "db/migrate/#{file}"


  # This is the base method used to navigational purposes.
  # It returns the model name from the current file.
  @getModelName: (file) ->
    regexps = [
      modelFileMatcher,
      controllerFileMatcher,
      viewFileMatcher,
      helperFileMatcher,
      migrationCreateFileMatcher,
      migrationModifyFilematcher
    ]

    for regexp in regexps
      if match = file.match regexp
        return AR.singularize(match[1])

  # Given an editor, try to find an action name if in one applicable file.
  @getActionName: (editor) ->
    filePath = editor.getPath()
    if match = filePath.match viewFileMatcher
      match[2]


  # Acordingly to the selected Editor and the file path function passed as
  # parameter, this method opens a new tab.
  @goTo: (fileKind) ->
    if editor = atom.workspace.getActiveEditor()
      modelName = Navigation.getModelName editor.getPath()

      targetFile = switch fileKind
        when "model"
          @modelFilePath(modelName)
        when "controller"
          @controllerFilePath(modelName)
        when "helper"
          @helperFilePath(modelName)
        when "migration"
          @migrationFilePath(modelName)

      atom.workspaceView.open(targetFile)
