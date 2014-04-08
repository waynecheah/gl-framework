'use strict'

glApp.users = angula
  .module 'glApp.users', [
    # module dependency
    #'glApp.users.factory'
  ]

  .config ['$routeProvider', ($routeProvider) ->
      $routeProvider
      .when '/users/login',
          templateUrl: 'users/login.html'
          controller: 'LoginCtrl'
      .when '/users/register',
          templateUrl: 'users/register.html'
          controller: 'RegisterCtrl'
      .otherwise
          redirectTo: '/'
      return
    ]

  .controller 'LoginController', ['$scope', '$routeParams', ($scope, $routeParams) ->
    console.log $routeParams
    $scope.username = 'username'
    $scope.password = 'password'
    return
  ]
  .controller 'LoginCtrl', ['$scope', 'auth', '$location', ($scope, auth, $location) ->
    formname = 'loginForm'

    $scope.login = ->
      if $scope[formname].$valid
        promise = auth.login $scope.user
        promise.then success, error
      return
    # END login

    success = (res) ->
      localStorage.setItem 'auth_token', res.data.auth_token
      $location.path '/dashboard'
      return
    # END success

    error = ->
      $scope.invalidCredentials = true
      return
    # END error
    return
  ]
  .controller 'RegisterCtrl', ['$scope', '$routeParams', ($scope, $routeParams) ->
    console.log $routeParams
    $scope.fullname = 'fullname'
    return
  ]
