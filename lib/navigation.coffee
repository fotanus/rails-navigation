CodeInspector = require './code-inspector'
FileInspector = require './file-inspector'
fs = require 'fs'
q = require 'q'

# Navigation class contains high-level methods that are binded on the main file.
module.exports =
class Navigation

  # Public: Given a file kind, goes to it taking in consideration the current
  # file.
  #
  # targetFileKind: A string for the target file. For example, "model" or "view"
  #
  # Returns nothing
  @goToFile: (targetFileKind) ->
    editor = atom.workspace.getActiveEditor()
    return q.reject("No active editorade") unless editor

    sourceFilePath = editor.getPath().replace(atom.project.getPath()+"/", "")
    return q.reject("Editor has no path") unless editor.getPath()

    modelName = FileInspector.getModelName sourceFilePath
    return q.reject("Can't find out model") unless modelName

    testSubject = CodeInspector.getCurrentSubject

    actionName = Navigation.getActionName(editor)
    if !actionName and targetFileKind == "view"
      return q.reject("Don't know what action to use")

    @getTargetFile(targetFileKind, modelName, actionName, sourceFilePath).then (targetFile) ->
      atom.workspaceView.open(targetFile).then (resultingEditor) ->
        CodeInspector.moveToSubject(resultingEditor, actionName)

  # Private: for the given parameters, decide the target file
  #
  # fileKind - the target file kind that needs to be open
  # modelName - the related model with the current file, singularized
  # actionName - the related action for the current file
  # sourceFilePath - the file that is current open
  #
  # Returns the promise of a file path
  @getTargetFile: (fileKind, modelName, actionName, sourceFilePath) ->
    switch fileKind
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
      when "test"
        FileInspector.testFilePath(sourceFilePath)

  # Private: gets the action for the given editor.
  #
  # editor - the editor we want to get the action from.
  #
  # Returns the action name
  @getActionName: (editor) ->
    FileInspector.getActionName(editor) || CodeInspector.getMethodName(editor)
