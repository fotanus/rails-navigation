{WorkspaceView} = require "atom"
Rails = require "../lib/rails"

describe "Rails", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    atom.packages.activatePackage("rails")

  describe "go-to-model", ->
    describe "from a non-model file", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open("app/controllers/users_controller.rb")

      it "opens a new tab for the module", ->
        runs ->
          atom.workspaceView.trigger 'rails:go-to-model'
          waitsForPromise ->
            Rails.promise()
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/models/user.rb");

  describe "go-to-controller", ->
    describe "from a non-controller file", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open("app/models/user.rb")

      it "opens a new tab for the controller", ->
        runs ->
          atom.workspaceView.trigger 'rails:go-to-controller'
          waitsForPromise ->
            Rails.promise()
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/controllers/users_controller.rb");
