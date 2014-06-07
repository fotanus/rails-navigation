# CodeInspector is responsible to respond to queries on the source code

module.exports =
class CodeInspector

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

  # For a given line, if is a method declaration, returns the name. Otherwise,
  # returns null
  @getMethodName: (line) ->
    if match = line.match /^\s*def\s\s*(\w+)/
      return match[1]
    else
      null
