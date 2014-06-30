FileInspector = require "./file-inspector"

# CodeInspector parse the contents of an editor and change the textbuffer or
# return information about the code around the cursor.
module.exports =
class CodeInspector

  # Public: Retrieves the method name which the cursor context currently is.
  # It works for models, controllers and tests.
  #
  # editor - the editor we want to inspect
  #
  # Returns the method name or null.
  @getMethodName: (editor) ->
    textInLines = editor.getText().split("\n")
    lineNumber = editor.getCursor().getBufferRow()
    while lineNumber > 0
      methodName = @getMethodNameFromLine(editor, textInLines[lineNumber])
      return methodName if methodName
      lineNumber -= 1
    null

  # Public: Move the cursor to the method definition (or test definition, or
  # spec)
  #
  # editor - the editor that needs the cursor moved
  # subject - the method name (or test base name) we want to get to
  #
  # Returns nothing.
  @moveToSubject: (editor, subject) ->
    textInLines = editor.getText().split("\n")
    lineNumber = 0;
    for line in textInLines
      if @getMethodNameFromLine(editor, line) == subject
        editor.setCursorScreenPosition([lineNumber, 0])
        editor.moveCursorToBeginningOfNextWord()
        return
      lineNumber += 1

  # Private: Returns the method name or test base name from one string.
  #
  # editor - the editor which have the line we need to analise
  # line - the line we want to get the method name from
  #
  # Returns a method name, or null.
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

  # Private: For a given method definition line, returns the method name.
  #
  # line - a line of code with a method definition.
  #
  # Returns the method name or null if can't find a method definition.
  @getMethodDefName: (line) ->
    if match = line.match /^\s*def\s\s*(\w+)/
      return match[1]
    else
      null

  # Private: For a standard Unit::Test method description, gets the method name
  # which the test description tests.
  #
  # line - a line of code with a method definition.
  #
  # Returns the method name or null if can't find a method definition.
  @getTestMethodName: (line) ->
    if match = line.match /^\s*test\s+("|')(#|\.)(\w+)("|')/
      return match[3]
    else
      null

  # Private: For a standard rspec method description, gets the method name which
  # the spec description tests.
  #
  # line - a line of code with a method definition.
  #
  # Returns the method name or null if can't find a method definition.
  @getSpecMethodName: (line) ->
    if match = line.match /^\s*describe\s+("|')(#|\.)(\w+)("|')/
      return match[3]
    else
      null
