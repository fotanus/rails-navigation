{WorkspaceView} = require "atom"
fs = require 'fs'
Navigation = require '../lib/navigation'

describe "Navigation", ->

  describe "getModelName", ->
    it "model", ->
      file = "/home/foo/work/project/app/models/user.rb"
      expect(Navigation.getModelName(file)).toBe "user"

    it "controller", ->
      file = "/home/foo/work/project/app/controllers/users_controller.rb"
      expect(Navigation.getModelName(file)).toBe "user"

    it "view", ->
      file = "/home/foo/work/project/app/views/users/index.html.erb"
      expect(Navigation.getModelName(file)).toBe "user"

    it "helper", ->
      file = "/home/foo/work/project/app/helpers/users_helper.rb"
      expect(Navigation.getModelName(file)).toBe "user"

    it "create migration", ->
      file = "/home/foo/work/project/db/migrate/123123_create_users.rb"
      expect(Navigation.getModelName(file)).toBe "user"

    it "modify migration", ->
      file = "/home/foo/work/project/db/migrate/123123_add_my_attribute_to_users.rb"
      expect(Navigation.getModelName(file)).toBe "user"


  describe "modelFilePath", ->
    it "returns the file path for a given model", ->
      expect(Navigation.modelFilePath("user")).toBe "app/models/user.rb"

  describe "controllerFilePath", ->
    it "returns the file path for a given model", ->
      expect(
        Navigation.controllerFilePath("user")
      ).toBe "app/controllers/users_controller.rb"

  describe "migrationFilePath", ->
    beforeEach ->
      spyOn(fs, 'readdirSync').andReturn(
        ["123123", "_users.rb", "123123_create_users.rb"]
      )

    it "returns the migration file path for a given model", ->
      expect(
        Navigation.migrationFilePath("user")
      ).toBe "db/migrate/123123_create_users.rb"


  describe "getActionName", ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView()
      atom.workspace = atom.workspaceView.model

    describe "when an action file is open", ->

      it "gets the view from the filename", ->
        editor = null
        runs ->
          waitsForPromise ->
            atom.workspace.open("/app/views/users/index.html.erb")
        runs ->
          editor = atom.workspace.getEditors()[0]
          expect(Navigation.getActionName(editor)).toBe "index"


  describe "goTo", ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView()
      atom.workspace = atom.workspaceView.model

    describe "When controller is currently selected", ->
      beforeEach ->
        waitsForPromise ->
          atom.workspace.open("app/controllers/users_controller.rb")

      it "opens a new tab for the module", ->
        runs ->
          waitsForPromise ->
            Navigation.goTo "model"
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
            Navigation.goTo "controller"
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/controllers/users_controller.rb");

      it "opens a new tab for the helper", ->
        runs ->
          waitsForPromise ->
            Navigation.goTo "helper"
        runs ->
          currentPath = atom.workspace.getActiveEditor().getPath()
          expect(atom.workspace.getEditors().length).toEqual(2)
          expect(currentPath).toMatch("app/helpers/users_helper.rb");
