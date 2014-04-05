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
    .when '/about',
        templateUrl: 'views/about.html'
        controller: 'MainCtrl'
    .when '/contact',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
    .otherwise
      redirectTo: '/'
    return
  ]
