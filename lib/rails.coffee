Navigation = require './navigation'

promise = null
module.exports =

  # HACK: This method is only used to retrieve the promisse by the tests.
  promise: ->
    promise

  activate: (state) ->
    atom.workspaceView.command "rails:go-to-model", @goToModel
    atom.workspaceView.command "rails:go-to-controller", @goToController

  goToModel: ->
    if editor = atom.workspace.getActiveEditor()
      modelName = Navigation.getModelName editor.getPath()
      targetFile = Navigation.modelFilePath modelName
      promise = atom.workspaceView.open(targetFile)

  goToController: ->
    if editor = atom.workspace.getActiveEditor()
      modelName = Navigation.getModelName editor.getPath()
      targetFile = Navigation.controllerFilePath modelName
      promise = atom.workspaceView.open(targetFile)
