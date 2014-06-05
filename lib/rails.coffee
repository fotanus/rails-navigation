Navigation = require './navigation'

module.exports =
  activate: (state) ->
    atom.workspaceView.command "rails:go-to-model", @goToModel

  goToModel: ->
    activeEditor = atom.workspace.getActiveEditor()
    if activeEditor != undefined
      modelName = Navigation.getModelName activeEditor.getPath()
      targetFile = Navigation.modelFilePath modelName
      waitsForPromise ->
        promise = atom.workspaceView.open(targetFile)
