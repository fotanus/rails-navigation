{View} = require 'atom'

module.exports =
class RailsView extends View
  @content: ->
    @div class: 'rails overlay from-top', =>
      @div "The Rails package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "rails:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "RailsView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
