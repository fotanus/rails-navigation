Navigation = require './navigation'

promise = null
module.exports =

  activate: (state) ->
    atom.workspaceView.command "rails:go-to-model", @goToModel
    atom.workspaceView.command "rails:go-to-controller", @goToController
    atom.workspaceView.command "rails:go-to-helper", @goToHelper
    atom.workspaceView.command "rails:go-to-migration", @goToMigration

  goToModel: ->
    Navigation.goTo "model"

  goToController: ->
    Navigation.goTo "controller"

  goToHelper: ->
    Navigation.goTo "helper"

  goToMigration: ->
    Navigation.goTo "migration"
