AR = require './active-record'
CodeInspector = require './code-inspector'
FileInspector = require './file-inspector'
fs = require 'fs'
q = require 'q'

# Navigation class contains methods used to navigate on
# rails directory structure

module.exports =
class Navigation

  # Given an editor, try to find an action name if in one applicable file.
  @getActionName: (editor) ->
    filePath = editor.getPath()
    if filePath
      if match = filePath.match FileInspector.viewFileMatcher()
        return match[2]
      if match = filePath.match FileInspector.legacyViewFileMatcher()
        return match[2]
      if filePath.match FileInspector.controllerFileMatcher()
        return CodeInspector.controllerCurrentAction(editor)
    null


  # Acordingly to the selected Editor and the file path function passed as
  # parameter, this method opens a new tab.
  @goTo: (fileKind) ->
    editor = atom.workspace.getActiveEditor()
    return q.reject("No active editorade") unless editor

    modelName = FileInspector.getModelName editor.getPath()
    return q.reject("Can't find out model") unless modelName

    actionName = Navigation.getActionName(editor)
    if !actionName and fileKind == "view"
      return q.reject("Don't know what action to use")

    targetFile = switch fileKind
      when "model"
        FileInspector.modelFilePath(modelName)
      when "controller"
        FileInspector.controllerFilePath(modelName)
      when "helper"
        FileInspector.helperFilePath(modelName)
      when "migration"
        FileInspector.migrationFilePath(modelName)
      when "view"
        FileInspector.viewFilePath(modelName, actionName)

    atom.workspaceView.open(targetFile)
