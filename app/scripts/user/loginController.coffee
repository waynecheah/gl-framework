'use strict'

angular.module 'glApp'
  .controller 'LoginController', ['$scope', 'auth', '$location', ($scope, auth, $location) ->
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