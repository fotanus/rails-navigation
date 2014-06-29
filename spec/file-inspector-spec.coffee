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
    it "returns the migration file path for a given model", ->
      expect(
        FileInspector.migrationFilePath("user")
      ).toBe "db/migrate/20140608214510_create_users.rb"

  describe "viewFilePath", ->
    describe "when template exists", ->
      it "returns the view file for the given model/action", ->
        expect(
          FileInspector.viewFilePath("user", "index")
        ).toBe "app/views/users/index.html.erb"

    describe "when old style template exists", ->
      it "returns the view file for the given model/action", ->
        expect(
          FileInspector.viewFilePath("user", "legacy_rhtml")
        ).toBe "app/views/users/legacy_rhtml.rhtml"

  describe "testFilePath", ->
    describe "when test unit exists", ->
      it "returns its path", ->
        expect(
          FileInspector.testFilePath("user", undefined)
        ).toBe "test/models/user_test.rb"

    describe "when spec exists", ->
      it "returns its path", ->
        expect(
          FileInspector.testFilePath("rspec_model", undefined)
        ).toBe "spec/models/rspec_model_spec.rb"

    #TODO: We could use a better behaviour here.
    describe "when template does not exist", ->
      it "returns null", ->
        expect(
          FileInspector.viewFilePath("user", "no_template")
        ).toBe null
