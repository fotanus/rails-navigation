{WorkspaceView} = require "atom"
fs = require 'fs'
Navigation = require '../lib/navigation'
CodeInspector = require '../lib/code-inspector'

describe "Navigation", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    atom.project.setPath("#{atom.project.getPath()}/test_project")

  describe "getActionName", ->
    describe "when an view file is open", ->
      beforeEach ->
        runs ->
          waitsForPromise ->
            atom.workspace.open("app/views/users/index.html.erb")
      it "gets the action from the filename", ->
        runs ->
          editor = atom.workspace.getEditors()[0]
          expect(Navigation.getActionName(editor)).toBe "index"

    describe "when an controller file is open", ->
      beforeEach ->
        runs ->
          waitsForPromise ->
            atom.workspace.open("app/controllers/users_controller.rb")

      describe "When the cursor is on the index action", ->
        beforeEach ->
          editor = atom.workspace.getEditors()[0]
          editor.setCursorBufferPosition([7,2])
        it "gets the action from code inspector", ->
          runs ->
            editor = atom.workspace.getEditors()[0]
            expect(Navigation.getActionName(editor)).toBe "index"


    describe "When can't discover the action name", ->
      beforeEach ->
        runs ->
          waitsForPromise ->
            atom.workspace.open("README.md")
      it "returns null", ->
        runs ->
          editor = atom.workspace.getEditors()[0]
          expect(Navigation.getActionName(editor)).toBe null

  describe "goToFile", ->
    describe "When controller is currently selected", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open("app/controllers/users_controller.rb")

      it "opens a new tab for the module", ->
        runs ->
          waitsForPromise ->
            Navigation.goToFile "model"
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/models/user.rb")

    describe "When a model is currently selected", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open("app/models/user.rb")

      it "opens a new tab for the controller", ->
        runs ->
          waitsForPromise ->
            Navigation.goToFile "controller"
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/controllers/users_controller.rb");

      it "opens a new tab for the test", ->
        runs ->
          waitsForPromise ->
            Navigation.goToFile "test"
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("test/models/user_test.rb");

      it "opens a new tab for the helper", ->
        runs ->
          waitsForPromise ->
            Navigation.goToFile "helper"
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/helpers/users_helper.rb");

    xdescribe "When there is no file open", ->
      it "fails", ->
        waitsForPromise {shouldReject: true}, =>
          Navigation.goToFile "controller"

    # TODO: Why this test won't pass?
    xdescribe "When can't decide the model", ->
      beforeEach ->
        runs ->
          waitsForPromise ->
            atom.workspace.open("README.md")

      it "fails", ->
        runs ->
          waitsForPromise {shouldReject: true}, ->
            Navigation.goToFile "controller"
