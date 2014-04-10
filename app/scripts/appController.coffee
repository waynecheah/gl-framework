'use strict'

glApp

    .controller 'MainCtrl', ['$scope', ($scope) ->
        $scope.crossbind = 'Default ng data'
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
            #debugger path+' is '+rs
            rs
        # END isActive
        return
    ]