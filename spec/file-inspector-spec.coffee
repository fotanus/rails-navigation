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
      FileInspector.modelFilePath("user").then (filePath) ->
        expect(filePath).toBe "app/models/user.rb"

  describe "controllerFilePath", ->
    it "returns the file path for a given model", ->
      FileInspector.controllerFilePath("user").then (filePath) ->
        expect(filePath).toBe "app/controllers/users_controller.rb"

  describe "migrationFilePath", ->
    it "returns the migration file path for a given model", ->
      FileInspector.migrationFilePath("user").then (filePath) ->
        expect(filePath).toBe "db/migrate/20140608214510_create_users.rb"

  describe "viewFilePath", ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView()
      atom.workspace = atom.workspaceView.model
      atom.project.setPath("#{atom.project.getPath()}/test_project")
      
      describe "when template exists", ->
        it "returns the view file for the given model/action", ->
          FileInspector.viewFilePath("user", "index").then (filePath) ->
            expect(filePath).toBe "app/views/users/index.html.erb"

      describe "when old style template exists", ->
        it "returns the view file for the given model/action", ->
          FileInspector.viewFilePath("user", "legacy_rhtml").then (filePath) ->
            expect(filePath).toBe "app/views/users/legacy_rhtml.rhtml"

  describe "testFilePath", ->
    describe "when in a model", ->
      describe "when test unit exists", ->
        it "returns its path", ->
          FileInspector.testFilePath("app/models/user.rb").then (filePath) ->
            expect(filePath).toBe "test/models/user_test.rb"

      describe "when spec exists", ->
        it "returns its path", ->
          FileInspector.testFilePath("app/models/rspec_model.rb").then (filePath) ->
            expect(filePath).toBe "spec/models/rspec_model_spec.rb"

    describe "when in a controller", ->
      describe "when test unit exists", ->
        it "returns its path", ->
          FileInspector.testFilePath("app/controllers/users_controller.rb").then (filePath) ->
            expect(filePath).toBe "test/controllers/users_controller_test.rb"

      describe "when spec exists", ->
        it "returns its path", ->
          FileInspector.testFilePath("app/controllers/rspec_models_controller.rb").then (filePath) ->
            expect(filePath).toBe "spec/controllers/rspec_models_controller_spec.rb"

    describe "when in a helper", ->
      describe "when test unit exists", ->
        it "returns its path", ->
          FileInspector.testFilePath("app/helpers/users_helper.rb").then (filePath) ->
            expect(filePath).toBe "test/helpers/users_helper_test.rb"

      describe "when spec exists", ->
        it "returns its path", ->
          FileInspector.testFilePath("app/helpers/rspec_models_helper.rb").then (filePath) ->
            expect(filePath).toBe "spec/helpers/rspec_models_helper_spec.rb"

    describe "when in a view", ->
      describe "when spec exists", ->
        it "returns its path", ->
          FileInspector.testFilePath("app/views/rspec_models/show.html.erb").then (filePath) ->
            expect(filePath).toBe "spec/views/rspec_models/show.html.erb_spec.rb"


    #TODO: We could use a better behaviour here.
    describe "when template does not exist", ->
      it "returns null", ->
        FileInspector.viewFilePath("user", "no_template").then (filePath) ->
          expect(filePath).toBe null
