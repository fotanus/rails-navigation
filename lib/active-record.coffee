# ActiveRecord class contains methods that needs to mimc rails active record
# implementation.

module.exports =
class ActiveRecord

    # Given a plural word, returns the singular. If it can't figure out the
    # singular for a given word, returns the word itself.
    @singularize: (name) ->
      if match = name.match /(\w+)s$/
        match[1]
      else
        name

    # Given a singular word, returns the plural.
    @pluralize: (name) ->
      name + 's'
