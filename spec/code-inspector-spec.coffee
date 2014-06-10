{WorkspaceView} = require "atom"
CodeInspector = require '../lib/code-inspector'

describe "codeInspector", ->

  describe "controllerCurrentAction", ->
    editor = null
    beforeEach ->
      runs ->
        atom.workspaceView = new WorkspaceView()
        atom.workspace = atom.workspaceView.model
        atom.workspace.open("dummy_controller.rb")
      waitsFor ->
        editor = atom.workspace.getEditors()[0]

    describe "For a simple method", ->
      beforeEach ->
        editor.setText("class Foo\ndef bar\nputs 1\nend\nend")

        describe "when cursor is on the method name line", ->
          beforeEach ->
            editor.setCursorBufferPosition([1,2])
          it "returns the method name", ->
            expect(CodeInspector.controllerCurrentAction(editor)).toBe "bar"

        describe "when cursor is on the method body", ->
          beforeEach ->
            editor.setCursorBufferPosition([2,2])
          it "returns the method name", ->
            expect(CodeInspector.controllerCurrentAction(editor)).toBe "bar"

        describe "when cursor is on the method end", ->
          beforeEach ->
            editor.setCursorBufferPosition([3,2])
          it "returns the method name", ->
            expect(CodeInspector.controllerCurrentAction(editor)).toBe "bar"

        describe "when cursor is after the method", ->
          beforeEach ->
            editor.setCursorBufferPosition([4,2])
          it "returns the method name", ->
            expect(CodeInspector.controllerCurrentAction(editor)).toBe "bar"

        describe "when cursor is before the method", ->
          beforeEach ->
            editor.setCursorBufferPosition([0,2])
          it "returns null", ->
            expect(CodeInspector.controllerCurrentAction(editor)).toBe null


  describe "getMethodName", ->
    it "matches a method declaration line", ->
      expect(CodeInspector.getMethodName("def foo_bar")).toBe "foo_bar"

    it "don't match a non-method declaration line", ->
      expect(CodeInspector.getMethodName("puts 'hello'")).toBe null

  describe "getTestSubject", ->
    it "matches a instance method test description", ->
      expect(CodeInspector.getTestSubject("test '#my_method'")).toBe "my_method"

    it "matches a instance method test description with double quotes", ->
      expect(CodeInspector.getTestSubject('test "#my_method"')).toBe "my_method"

    it "matches a class method test description", ->
      expect(CodeInspector.getTestSubject('test ".my_method"')).toBe "my_method"

    it "don't match a non-method declaration line", ->
      expect(CodeInspector.getTestSubject("test 'any test'")).toBe null


  describe "getSpecSubject", ->
    it "matches a instance method spec description", ->
      expect(CodeInspector.getSpecSubject("describe '#my_method'")).toBe "my_method"

    it "matches a instance method spec description with double quotes", ->
      expect(CodeInspector.getSpecSubject('describe "#my_method"')).toBe "my_method"

    it "matches a class method spec description", ->
      expect(CodeInspector.getSpecSubject('describe ".my_method"')).toBe "my_method"

    it "don't match a non-method declaration line", ->
      expect(CodeInspector.getSpecSubject("describe 'any spec'")).toBe null
