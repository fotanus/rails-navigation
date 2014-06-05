ActiveRecord = require '../lib/active-record'

describe "ActiveRecord", ->
  describe "singularize", ->
    it "remove last 's'", ->
      expect(ActiveRecord.singularize("tests")).toBe("test")

    it "remove only last 's'", ->
      expect(ActiveRecord.singularize("abcss")).toBe("abcs")

    it "returns the word if not ending with s", ->
      expect(ActiveRecord.singularize("user")).toBe("user")
