RailsView = require './rails-view'

module.exports =
  railsView: null

  activate: (state) ->
    @railsView = new RailsView(state.railsViewState)

  deactivate: ->
    @railsView.destroy()

  serialize: ->
    railsViewState: @railsView.serialize()
