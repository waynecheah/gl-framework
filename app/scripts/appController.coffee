'use strict'

glApp.controller 'MainCtrl', ['$scope', ($scope) ->
    $scope.crossBind = 'Default Angular'
    $scope.pageTitle = 'Angular + Polymer'
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
    return
  ]

  .controller 'navigationCtrl', ['$scope', '$location', ($scope, $location) ->
    $scope.isActive = (path) ->
      rs = path is $location.path()
      console.log path+' is '+rs
      rs
    # END isActive
    return
  ]