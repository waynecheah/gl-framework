'use strict'

glApp = angular
  .module 'glApp', [
    'ngResource'
    'ngSanitize'
    'ngRoute'
    'glApp.users'
  ]
  .factory 'authInterceptor', ->
    request: (config) ->
      config.headers       = config.headers || {}
      config.headers.token = localStorage.auth_token if localStorage.oauth_token
      config
  .config ['$httpProvider', ($httpProvider) ->
      $httpProvider.interceptors.push 'authInterceptor'
  ]
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .when '/about',
        templateUrl: 'views/about.html'
        controller: 'MainCtrl'
    .when '/login',
        templateUrl: 'views/login.html'
        controller: 'MainCtrl'
    .otherwise
      redirectTo: '/'
    return
  ]
