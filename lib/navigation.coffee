AR = require './active-record'

# Navigation class contains methods used to navigate on
# rails directory structure

module.exports =
class Navigation
  promise = null

  # Given a model name, returns the file path for that model.
  @modelFilePath: (model) ->
    "app/models/#{model}.rb"

  # Given a model name, returns the file path for the respective controller
  @controllerFilePath: (model) ->
    "app/controllers/#{AR.pluralize(model)}_controller.rb"

  # This is the base method used to navigational pourposes.
  # It returns the model name from the current file.
  @getModelName: (file) ->
    regexps = [
      /\/models\/(\w+)\.rb$/,
      /\/controllers\/(\w+)_controller\.rb$/,
      /\/views\/(\w+)\/.*rb$/,
      /\/helpers\/(\w+)_helper\.rb$/,
      /\/migrate\/[0-9]+_create_(\w+)\.rb$/,
      /\/migrate\/[0-9]+_add_\w+_to_(\w+)\.rb$/
    ]

    for regexp in regexps
      if match = file.match regexp
        return AR.singularize(match[1])

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

      promise = atom.workspaceView.open(targetFile)

  # HACK: This method is only used to retrieve the promisse by the tests.
  # promise is set on goTo method.
  @promise: ->
    promise
