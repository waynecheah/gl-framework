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
