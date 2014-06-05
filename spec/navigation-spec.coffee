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
