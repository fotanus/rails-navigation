AR = require './active-record'

# Navigation class contains methods used to navigate on
# rails directory structure

module.exports =
class Navigation

  # This is the base method used to navigational pourposes.
  # It returns the model name from the current file.
  @getModelName: (file) ->
    regexps = [
      /\/models\/(\w+)\.rb$/,
      /\/controllers\/(\w+)_controller\.rb$/,
      /\/views\/(\w+)\/.*rb$/,
      /\/helpers\/(\w+)_helper\.rb$/,
      /\/migrate\/[0-9]+_create_(\w+)\.rb$/,
      /\/migrate\/[0-9]+_add_\w+_to_(\w+)\.rb$/
    ]

    for regexp in regexps
      if match = file.match regexp
        return AR.singularize(match[1])
