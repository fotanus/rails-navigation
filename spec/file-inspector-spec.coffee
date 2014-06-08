{WorkspaceView} = require "atom"
fs = require 'fs'
FileInspector = require '../lib/file-inspector'

describe "FileInspector", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    atom.project.setPath("#{atom.project.getPath()}/test_project")

  describe "getModelName", ->
    it "gets the model name from a model", ->
      file = "/home/foo/work/project/app/models/user.rb"
      expect(FileInspector.getModelName(file)).toBe "user"

    it "gets the model name from a controller", ->
      file = "/home/foo/work/project/app/controllers/users_controller.rb"
      expect(FileInspector.getModelName(file)).toBe "user"

    it "gets the model name from a view", ->
      file = "/home/foo/work/project/app/views/users/index.html.erb"
      expect(FileInspector.getModelName(file)).toBe "user"

    it "gets the model name from an old style view", ->
      file = "/home/foo/work/project/app/views/users/index.rhtml"
      expect(FileInspector.getModelName(file)).toBe "user"

    it "gets the model name from a helper", ->
      file = "/home/foo/work/project/app/helpers/users_helper.rb"
      expect(FileInspector.getModelName(file)).toBe "user"

    it "gets the model name from a create migration", ->
      file = "/home/foo/work/project/db/migrate/123123_create_users.rb"
      expect(FileInspector.getModelName(file)).toBe "user"

    it "gets the model name from a modify migration", ->
      file = "/home/foo/work/project/db/migrate/123123_add_my_attribute_to_users.rb"
      expect(FileInspector.getModelName(file)).toBe "user"


  describe "modelFilePath", ->
    it "returns the file path for a given model", ->
      expect(FileInspector.modelFilePath("user")).toBe "app/models/user.rb"

  describe "controllerFilePath", ->
    it "returns the file path for a given model", ->
      expect(
        FileInspector.controllerFilePath("user")
      ).toBe "app/controllers/users_controller.rb"

  describe "migrationFilePath", ->
    beforeEach ->
      spyOn(fs, 'readdirSync').andReturn(
        ["123123", "_users.rb", "123123_create_users.rb"]
      )

    it "returns the migration file path for a given model", ->
      expect(
        FileInspector.migrationFilePath("user")
      ).toBe "db/migrate/123123_create_users.rb"

  describe "viewFilePath", ->
    describe "when template exists", ->
      beforeEach ->
        spyOn(fs, 'readdirSync').andReturn(
          ["destroy.html.erb", "index.html.erb", "create.html.erb"]
        )

      it "returns the view file for the given model/action", ->
        expect(
          FileInspector.viewFilePath("user", "index")
        ).toBe "app/views/users/index.html.erb"

    describe "when old style template exists", ->
      beforeEach ->
        spyOn(fs, 'readdirSync').andReturn(
          ["destroy.html.erb", "index.rhtml", "create.html.erb"]
        )

      it "returns the view file for the given model/action", ->
        expect(
          FileInspector.viewFilePath("user", "index")
        ).toBe "app/views/users/index.rhtml"

    describe "when template does not exist", ->
      beforeEach ->
        spyOn(fs, 'readdirSync').andReturn(
          ["destroy.html.erb", "create.html.erb"]
        )

      #TODO: We could use a better behaviour here.
      it "returns null", ->
        expect(
          FileInspector.viewFilePath("user", "index")
        ).toBe null
