FileInspector = require "./file-inspector"
# CodeInspector is responsible to respond to queries on the source code

module.exports =
class CodeInspector

  # If possible to known the action name based on the cursor location, returns
  # it. Returns null otherwise.
  @getMethodName: (editor) ->
    textInLines = editor.getText().split("\n")
    lineNumber = editor.getCursor().getBufferRow()
    while lineNumber > 0
      methodName = @getMethodNameFromLine(editor, textInLines[lineNumber])
      return methodName if methodName
      lineNumber -= 1
    null

  # Given a editor and a subject, move the curent cursor to the subject. Subject
  # currently needs to be a function name.
  @moveToSubject: (editor, subject) ->
    textInLines = editor.getText().split("\n")
    lineNumber = 0;
    for line in textInLines
      if @getMethodNameFromLine(editor, line) == subject
        editor.setCursorScreenPosition([lineNumber, 0])
        editor.moveCursorToBeginningOfNextWord()
        return
      lineNumber += 1

  # Returns the method name. It works if the line is a method definition or a
  # test method with that name
  @getMethodNameFromLine: (editor, line) ->
    path = editor.getPath()
    if FileInspector.isController(path) || FileInspector.isModel?(path)
      @getMethodDefName line
    else if FileInspector.isSpec path
      @getSpecMethodName line
    else if FileInspector.isTest path
      @getTestMethodName line
    else
      null

  # For a given line, if is a method declaration, returns the name. Otherwise,
  # returns null
  @getMethodDefName: (line) ->
    if match = line.match /^\s*def\s\s*(\w+)/
      return match[1]
    else
      null

  # For a given line, test if is the start of a test subject. Tests subjects
  # have this format: `test "#method"` or `test ".method"`.
  @getTestMethodName: (line) ->
    if match = line.match /^\s*test\s+("|')(#|\.)(\w+)("|')/
      return match[3]
    else
      null

  # For a given line, test if is the start of a spec subject. Spec subjects
  # have this format: `describe "#method"` or `describe ".method"`.
  @getSpecMethodName: (line) ->
    if match = line.match /^\s*describe\s+("|')(#|\.)(\w+)("|')/
      return match[3]
    else
      null
