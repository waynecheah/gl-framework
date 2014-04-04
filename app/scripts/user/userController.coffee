'use strict'

glApp.users.controller 'LoginCtrl',
['$scope', '$routeParams', ($scope, $routeParams) ->
  console.log $routeParams
  $scope.username = 'username'
  $scope.password = 'password'
  return
]
.controller 'RegisterCtrl',
['$scope', '$routeParams', ($scope, $routeParams) ->
  console.log $routeParams
  $scope.fullname = 'fullname'
  return
]