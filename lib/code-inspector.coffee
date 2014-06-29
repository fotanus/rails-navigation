FileInspector = require "./file-inspector"
# CodeInspector is responsible to respond to queries on the source code

module.exports =
class CodeInspector

  # If possible to known the action name based on the cursor location, returns
  # it. Returns null otherwise.
  @getActionName: (editor) ->
    filePath = editor.getPath()
    if FileInspector.isController(filePath)
      return CodeInspector.controllerCurrentAction(editor)
    null

  # Given a editor and a subject, move the curent cursor to the subject. Subject
  # currently needs to be a function name.
  @moveToSubject: (editor, subject) ->
    textInLines = editor.getText().split("\n")
    lineNumber = 0;
    for line in textInLines
      if line.match new RegExp("\\s*def\\s*(self\\.)?" + subject)
        editor.setCursorScreenPosition([lineNumber, 0])
        editor.moveCursorToBeginningOfNextWord()
        return
      lineNumber += 1


  # For a given editor, returns the name of the action on which the cursor
  # is currently in
  @controllerCurrentAction: (editor) ->
    textInLines = editor.getText().split("\n")
    lineNumber = editor.getCursor().getBufferRow()
    while lineNumber > 0
      methodName = @getMethodName textInLines[lineNumber]
      return methodName if methodName
      lineNumber -= 1
    null

  # Given a unit or function test::unit gets the current subject and action
  @getCurrentSubject: (editor) ->
    textInLines = editor.getText().split("\n")
    lineNumber = editor.getCursor().getBufferRow()
    while lineNumber > 0
      methodName = @getTestSubject textInLines[lineNumber]
      return methodName if methodName
      lineNumber -= 1
    null

  # For a given line, if is a method declaration, returns the name. Otherwise,
  # returns null
  @getMethodName: (line) ->
    if match = line.match /^\s*def\s\s*(\w+)/
      return match[1]
    else
      null

  # For a given line, test if is the start of a test subject. Tests subjects
  # have this format: `test "#method"` or `test ".method"`.
  @getTestSubject: (line) ->
    if match = line.match /^\s*test\s+("|')(#|\.)(\w+)("|')/
      return match[3]
    else
      null

  # For a given line, test if is the start of a spec subject. Spec subjects
  # have this format: `describe "#method"` or `describe ".method"`.
  @getSpecSubject: (line) ->
    if match = line.match /^\s*describe\s+("|')(#|\.)(\w+)("|')/
      return match[3]
    else
      null
