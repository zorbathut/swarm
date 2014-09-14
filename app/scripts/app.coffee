'use strict'

###*
 # @ngdoc overview
 # @name swarmApp
 # @description
 # # swarmApp
 #
 # Main module of the application.
###
angular.module 'swarmApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
    # autogenerated files specific to this project
    'swarmEnv', 'swarmSpreadsheetPreload'
    # http://luisfarzati.github.io/angulartics/
    'angulartics', 'angulartics.google.analytics'
    # https://github.com/chieffancypants/angular-hotkeys/
    # TODO: hotkeys disabled for now.
    #'cfp.hotkeys'
  ]
angular.module('swarmApp').config ($routeProvider) ->
    $routeProvider
      .when '/debug',
        templateUrl: 'views/debug.html'
        controller: 'DebugCtrl'
      #.when '/',
      #  templateUrl: 'views/unitlist.html'
      #  controller: 'UnitlistCtrl'
      .when '/options',
        templateUrl: 'views/options.html'
        controller: 'OptionsCtrl'
      .when '/changelog',
        templateUrl: 'views/changelog.html'
        controller: 'ChangelogCtrl'
      .when '/statistics',
        templateUrl: 'views/statistics.html'
        controller: 'StatisticsCtrl'
      .when '/achievements',
        templateUrl: 'views/achievements.html'
        controller: 'AchievementsCtrl'
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/tab/:tab/unit/:unit',
        templateUrl: 'views/unit.html'
        controller: 'MainCtrl'
      .when '/tab/:tab',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

angular.module('swarmApp').config (env, $logProvider) ->
  $logProvider.debugEnabled env.isDebugLogged

angular.module('swarmApp').config (env, version) ->
  if env.gaTrackingID and window.ga?
    #console.log 'analytics', gaTrackingID
    window.ga 'create', env.gaTrackingID, 'auto'
    # appVersion breaks analytics, presumably because it's mobile-only.
    #window.ga 'set', 'appVersion', version

# http and https use different localstorage, which might confuse folks.
# angular $location doesn't make protocol mutable, so use window.location.
# allow an out for testing, though.
angular.module('swarmApp').run (env, $location, $log) ->
  # ?allowinsecure=0 is false, for example
  falsemap = {0:false,'':false,'false':false}
  allowinsecure = $location.search().allowinsecure ? env.httpsAllowInsecure
  allowinsecure = falsemap[allowinsecure] ? true
  $log.debug 'protocol check', allowinsecure, $location.protocol()
  # $location.protocol() == 'http', but window.location.protocol == 'http:' and you can't assign $location.protocol()
  # NOPE, in firefox there's no ':', https://bugzilla.mozilla.org/show_bug.cgi?id=726779 https://github.com/erosson/swarm/issues/68
  # chrome and IE don't mind the missing ':' though. I'm amazed - IE is supposed to be the obnoxious browser
  if $location.protocol() == 'http' and not allowinsecure
    window.location.protocol = 'https'
    $log.debug "window.location.protocol = 'https:'"
