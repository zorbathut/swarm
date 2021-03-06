'use strict'

###*
 # @ngdoc directive
 # @name swarmApp.directive:tabs
 # @description
 # # tabs
###
angular.module('swarmApp').directive 'tabs', (game, util, options, version, commands, env) ->
  templateUrl: 'views/tabs.html'
  scope:
    cur: '='
  restrict: 'E'
  link: (scope, element, attrs) ->
    scope.tabs = game.tabs
    scope.options = options
    scope.game = game
    scope.isOffline = env.isOffline

    scope.filterVisible = (tab) -> tab.isVisible()

    scope.buyUpgrades = (upgrades, costPercent=1) ->
      commands.buyAllUpgrades upgrades:upgrades, percent:costPercent

    util.animateController scope, game:game, options:options

    scope.undo = ->
      if scope.isUndoable()
        commands.undo()
    scope.secondsSinceLastAction = ->
      return (game.now.getTime() - (commands._undo?.date?.getTime?() ? 0)) / 1000
    scope.undoLimitSeconds = 30
    scope.isRedo = ->
      commands._undo?.isRedo
    scope.isUndoable = ->
      return scope.secondsSinceLastAction() < scope.undoLimitSeconds and not scope.isRedo()
      
