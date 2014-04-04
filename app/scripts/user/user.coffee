'use strict'

glApp.users = angular
  .module 'glApp.users', [
    #'glApp.users.factory'
  ]
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/users/register',
      templateUrl: '/view/users/register.html'
      controller: 'RegisterCtrl'
    .when '/users/login',
      templateUrl: '/view/users/login.html'
      controller: 'LoginCtrl'
    .otherwise
      redirectTo: '/'
    return
  ]
