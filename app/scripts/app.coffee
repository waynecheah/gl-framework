'use strict'

glApp = angular
  .module 'glApp', [
    'ngResource'
    'ngSanitize'
    'ngRoute'
    'glApp.users'
  ]
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .otherwise
      redirectTo: '/'
    return
  ]
