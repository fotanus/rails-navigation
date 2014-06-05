{WorkspaceView} = require "atom"
Rails = require "../lib/rails"

describe "Rails", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    atom.packages.activatePackage("rails")

  describe "go-to-model", ->
    describe "from a controller file", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open("app/controllers/users_controller.rb")

      it "opens a new tab for the module", ->
        runs ->
          atom.workspaceView.trigger 'rails:go-to-model'
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/models/user.rb");
