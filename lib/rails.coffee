Navigation = require './navigation'

promise = null
module.exports =

  activate: (state) ->
    atom.workspaceView.command "rails:go-to-model", @goToModel
    atom.workspaceView.command "rails:go-to-controller", @goToController

  goToModel: ->
    Navigation.goTo "model"

  goToController: ->
    Navigation.goTo "controller"
