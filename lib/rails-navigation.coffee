Navigation = require './navigation'
module.exports =
  activate: (state) ->
    atom.workspaceView.command "rails:go-to-model", @goToModel
    atom.workspaceView.command "rails:go-to-controller", @goToController
    atom.workspaceView.command "rails:go-to-helper", @goToHelper
    atom.workspaceView.command "rails:go-to-migration", @goToMigration
    atom.workspaceView.command "rails:go-to-view", @goToView
    atom.workspaceView.command "rails:go-to-test", @goToTest

  goToModel: ->
    Navigation.goToFile "model"

  goToController: ->
    Navigation.goToFile "controller"

  goToHelper: ->
    Navigation.goToFile "helper"

  goToMigration: ->
    Navigation.goToFile "migration"

  goToView: ->
    Navigation.goToFile "view"

  goToTest: ->
    Navigation.goToFile "test"
